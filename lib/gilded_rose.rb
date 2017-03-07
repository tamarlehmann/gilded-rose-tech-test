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
      if !is_aged_brie?(item) and !is_backstage_pass?(item)
        if is_in_range?(item)
          if !is_sulfuras?(item)
            change_quality(item, -1)
          end
        end
      else
        if is_in_range?(item)
          item.quality = item.quality + 1
          if is_backstage_pass?(item)
            if item.sell_in < BSPASS_TEN_DAY_THRESHOLD
              if is_in_range?(item)
                change_quality(item, +1)
              end
            end
            if item.sell_in < BSPASS_FIVE_DAY_THRESHOLD
              if is_in_range?(item)
                change_quality(item, +1)
              end
            end
          end
        end
      end
      if !is_sulfuras?(item)
        item.sell_in = item.sell_in - 1
      end
      if item.sell_in < MIN_THRESHOLD
        if !is_aged_brie?(item)
          if !is_backstage_pass?(item)
            if is_in_range?(item)
              if !is_sulfuras?(item)
                change_quality(item, -1)
              end
            end
          else
            item.quality = 0
          end
        else
          if is_in_range?(item)
            change_quality(item, +1)
          end
        end
      end
    end
  end

  private

  def is_normal_item?(item)
    !is_aged_brie?(item) && !is_backstage_pass?(item) && !is_backstage_pass?(item) && !is_sulfuras?(item)
  end

  def change_quality(item, amount)
    item.quality = item.quality + amount
  end

  def is_in_range?(item)
    item.quality > MIN_THRESHOLD && item.quality < MAX_THRESHOLD
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
