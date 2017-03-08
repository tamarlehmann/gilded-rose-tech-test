require 'gilded_rose'

describe GildedRose do

  describe "#update_quality" do
    it "Does not change the name" do
      items = [Item.new("foo", 0, 0)]
      GildedRose.new(items).update_quality()
      expect(items[0].name).to eq "foo"
    end

    it "Quality degrades as sell-by date approaches" do
      items = [Item.new("foo", 5, 5)]
      GildedRose.new(items).update_quality()
      expect(items[0].quality).to eq 4
    end

    it 'Quality degrates twice as fast after sell-by date' do
      items = [Item.new("foo", 0, 5)]
      GildedRose.new(items).update_quality()
      expect(items[0].quality).to eq 3
    end

    it "Degrades sell_in value by 1" do
      items = [Item.new("foo", 2, 5)]
      GildedRose.new(items).update_quality()
      expect(items[0].sell_in).to eq 1
    end

    it 'Quality can never been negative' do
      items = [Item.new("foo", 2, 0)]
      GildedRose.new(items).update_quality()
      expect(items[0].quality).to eq 0
    end

    it 'Quality can never be greater than 50' do
      items = [Item.new("Aged Brie", 2, 50)]
      GildedRose.new(items).update_quality()
      expect(items[0].quality).to eq 50
    end

    context "#Item: Aged Brie" do
      it 'Aged Brie does not decrease in quality as it ages' do
        items = [Item.new("Aged Brie", 2, 1)]
        GildedRose.new(items).update_quality()
        expect(items[0].quality).not_to eq 0
      end

      it 'Aged Brie increases in quality as it ages' do
        items = [Item.new("Aged Brie", 2, 0)]
        GildedRose.new(items).update_quality()
        expect(items[0].quality).to eq 1
      end
    end

    context "#Item: Sulfuras" do
      it 'Sulfuras never decrease in quality' do
        items = [Item.new("Sulfuras, Hand of Ragnaros", 0, 80)]
        GildedRose.new(items).update_quality()
        expect(items[0].quality).to eq 80
      end

      it 'Sulfuras sell-in value never decreases' do
        items = [Item.new("Sulfuras, Hand of Ragnaros", 0, 80)]
        GildedRose.new(items).update_quality()
        expect(items[0].sell_in).to eq 0
      end
    end

    context "#Item: Backstage Passes" do
      it 'Backstage passes increase quality x1 as sell-by date approaches' do
        items = [Item.new("Backstage passes to a TAFKAL80ETC concert", 15, 1)]
        GildedRose.new(items).update_quality()
        expect(items[0].quality).to eq 2
      end

      it 'Backstage passes increase in quality x2 when sell-by date is in < 10 days' do
        items = [Item.new("Backstage passes to a TAFKAL80ETC concert", 10, 1)]
        GildedRose.new(items).update_quality()
        expect(items[0].quality).to eq 3
      end

      it 'Backstage passes increase in quality x3 when sell-by date is in < 5 days' do
        items = [Item.new("Backstage passes to a TAFKAL80ETC concert", 4, 1)]
        GildedRose.new(items).update_quality()
        expect(items[0].quality).to eq 4
      end

      it 'Backstage passes quality drop to 0 after sell-by date has passed' do
        items = [Item.new("Backstage passes to a TAFKAL80ETC concert", 0, 5)]
        GildedRose.new(items).update_quality()
        expect(items[0].quality).to eq 0
      end
    end

    context "#Item: Conjured" do
      it "Conjured Items degrade in quality twice as fast as normal items" do
        items = [Item.new("Conjured Mana Cake", 5, 6)]
        expect{GildedRose.new(items).update_quality()}.to change{items[0].quality}.by -2
      end

      it "Conjured Items degrade in quality twice as fast after sell-by date" do
        items = [Item.new("Conjured Mana Cake", 0, 6)]
        expect{GildedRose.new(items).update_quality()}.to change{items[0].quality}.by -4
      end
    end
  end

end
