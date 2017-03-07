require_relative 'item'

class GildedRose
  MIN_QUALITY = 0
  MAX_QUALITY = 50
  BSPASS_TEN_DAY_THRESHOLD = 11
  BSPASS_FIVE_DAY_THRESHOLD = 6

  def initialize(items)
    @items = items
  end

  def update_quality()
    @items.each do |item|
      if !is_aged_brie?(item) and !is_backstage_pass?(item)
        if item.quality > MIN_QUALITY
          if !is_sulfuras?(item)
            item.quality = item.quality - 1
          end
        end
      else
        if item.quality < MAX_QUALITY
          item.quality = item.quality + 1
          if is_backstage_pass?(item)
            if item.sell_in < BSPASS_TEN_DAY_THRESHOLD
              if item.quality < MAX_QUALITY
                item.quality = item.quality + 1
              end
            end
            if item.sell_in < BSPASS_FIVE_DAY_THRESHOLD
              if item.quality < MAX_QUALITY
                item.quality = item.quality + 1
              end
            end
          end
        end
      end
      if !is_sulfuras?(item)
        item.sell_in = item.sell_in - 1
      end
      if item.sell_in < 0
        if !is_aged_brie?(item)
          if !is_backstage_pass?(item)
            if item.quality > MIN_QUALITY
              if !is_sulfuras?(item)
                item.quality = item.quality - 1
              end
            end
          else
            item.quality = item.quality - item.quality
          end
        else
          if item.quality < MAX_QUALITY
            item.quality = item.quality + 1
          end
        end
      end
    end
  end

  private

  def is_aged_brie?(item)
    item.name == "Aged Brie"
  end

  def is_backstage_pass?(item)
    item.name == "Backstage passes to a TAFKAL80ETC concert"
  end

  def is_sulfuras?(item)
    item.name == "Sulfuras, Hand of Ragnaros"
  end
end
