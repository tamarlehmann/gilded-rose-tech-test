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
      if item.name != "Aged Brie" and item.name != "Backstage passes to a TAFKAL80ETC concert"
        if item.quality > MIN_QUALITY
          if item.name != "Sulfuras, Hand of Ragnaros"
            item.quality = item.quality - 1
          end
        end
      else
        if item.quality < MAX_QUALITY
          item.quality = item.quality + 1
          if item.name == "Backstage passes to a TAFKAL80ETC concert"
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
      if item.name != "Sulfuras, Hand of Ragnaros"
        item.sell_in = item.sell_in - 1
      end
      if item.sell_in < 0
        if item.name != "Aged Brie"
          if item.name != "Backstage passes to a TAFKAL80ETC concert"
            if item.quality > MIN_QUALITY
              if item.name != "Sulfuras, Hand of Ragnaros"
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
end
