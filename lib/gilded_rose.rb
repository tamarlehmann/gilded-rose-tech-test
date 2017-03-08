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
      change_sellin(item)
      calculate_normal_quality(item) if is_normal_item?(item)
      calculate_conjured_quality(item) if is_conjured?(item)
      calculate_backstage_quality(item) if is_backstage_pass?(item)
      calculate_brie_quality(item) if is_aged_brie?(item)
    end
  end

  private

  def no_quality(item)
    item.quality = MIN_THRESHOLD
  end

  def calculate_normal_quality(item)
    passed_sellby_date?(item) ? (change_quality(item, -2)) : (change_quality(item, -1))
  end

  def is_normal_item?(item)
    !is_aged_brie?(item) && !is_backstage_pass?(item) && !is_conjured?(item) && !is_sulfuras?(item)
  end

  def change_quality(item, amount)
    item.quality += amount if quality_is_in_range?(item) || (is_aged_brie?(item) && item.quality < MAX_THRESHOLD)
  end

  def change_sellin(item)
    item.sell_in -= 1 unless is_sulfuras?(item)
  end

  def quality_is_in_range?(item)
    item.quality > MIN_THRESHOLD && item.quality < MAX_THRESHOLD
  end

  def passed_sellby_date?(item)
    item.sell_in < MIN_THRESHOLD
  end

  def is_aged_brie?(item)
    item.name == "Aged Brie"
  end

  def calculate_brie_quality(item)
    change_quality(item, +1)
  end

  def is_backstage_pass?(item)
    item.name == "Backstage passes to a TAFKAL80ETC concert"
  end

  def calculate_backstage_quality(item)
    change_quality(item, 1) if item.sell_in > BSPASS_TEN_DAY_THRESHOLD
    change_quality(item, 2) if item.sell_in < BSPASS_TEN_DAY_THRESHOLD && item.sell_in > BSPASS_FIVE_DAY_THRESHOLD
    change_quality(item, 3) if item.sell_in < BSPASS_FIVE_DAY_THRESHOLD
    no_quality(item) if passed_sellby_date?(item)
  end

  def is_sulfuras?(item)
    item.name == "Sulfuras, Hand of Ragnaros"
  end

  def is_conjured?(item)
    item.name == "Conjured Mana Cake"
  end

  def calculate_conjured_quality(item)
    passed_sellby_date?(item) ? (change_quality(item, -4)) : (change_quality(item, -2))
  end
end
