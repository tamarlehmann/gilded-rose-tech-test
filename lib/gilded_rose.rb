require_relative 'item'

class GildedRose
  MIN_THRESHOLD = 0
  MAX_THRESHOLD = 50
  BSPASS_TEN_DAY_THRESHOLD = 11
  BSPASS_FIVE_DAY_THRESHOLD = 6

  def initialize(items)
    @items = items
  end

  def update_quality()
    @items.each do |item|
      change_sellin(item) unless is_sulfuras?(item)
      change_quality(item, -1) if is_normal_item?(item)

      if !is_normal_item?(item)
        change_quality(item, -2) if is_conjured?(item)
        change_quality(item, +1) if is_aged_brie?(item)
        calculate_backstage_quality(item) if is_backstage_pass?(item)
      end

      if passed_sellby_date?(item)
        change_quality(item, +1) if is_aged_brie?(item)
        no_quality(item) if is_backstage_pass?(item)
        change_quality(item, -1) if is_normal_item?(item)
        change_quality(item, -2) if is_conjured?(item)
      end
    end
  end

  private

  def no_quality(item)
    item.quality = MIN_THRESHOLD
  end

  def calculate_backstage_quality(item)
    change_quality(item, +1) if item.sell_in > BSPASS_TEN_DAY_THRESHOLD
    change_quality(item, +2) if item.sell_in < BSPASS_TEN_DAY_THRESHOLD && item.sell_in > BSPASS_FIVE_DAY_THRESHOLD
    change_quality(item, +3) if item.sell_in < BSPASS_FIVE_DAY_THRESHOLD
  end

  def is_normal_item?(item)
    !is_aged_brie?(item) && !is_backstage_pass?(item) && !is_conjured?(item) && !is_sulfuras?(item)
  end

  def change_quality(item, amount)
    item.quality = item.quality + amount if is_in_range?(item)
  end

  def change_sellin(item)
    item.sell_in = item.sell_in - 1
  end

  def is_in_range?(item)
    item.quality > MIN_THRESHOLD && item.quality < MAX_THRESHOLD
  end

  def passed_sellby_date?(item)
    item.sell_in < MIN_THRESHOLD
  end

  def is_aged_brie?(item)
    item.name == "Aged Brie"
  end

  def is_backstage_pass?(item)
    item.name == "Backstage passes to a TAFKAL80ETC concert"
  end

  def is_sulfuras?(item)
    item.name == "Sulfuras, Hand of Ragnaros"
  end

  def is_conjured?(item)
    item.name == "Conjured Mana Cake"
  end
end
