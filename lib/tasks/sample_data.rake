namespace :db do
  desc "Erase and fill database"
  task :populate => :environment do
    require 'faker'
    require 'populator'
    require 'active_support/core_ext'
    
    [Account, Credit, CreditHistory, Filter, Notice,
     Notification, PaymentType, PaymentTypeSelection, Selection,
     Service, ServicePrice, Subscription].each(&:delete_all)

    make_accounts
    make_services
    make_subscriptions
    make_notifications

    Rake::Task['thinking_sphinx:index'].invoke
  end
end

def make_accounts
  Account.create!( 
    :email                  => "kayakentli@hotmail.com",
    :password               => "123456",
    :password_confirmation  => "123456"
  )

  20.times do |n|
    email = Faker::Internet.email
    account = Account.create!(
      :email                  => email,
      :password               => "123456",
      :password_confirmation  => "123456"
    )
    puts account
  end

end


def make_services
  service = {
    "title"              => "Acil Kan Servisi",
    "description"        => Faker::Lorem.paragraph(5),
    "filters_attributes"  => {
      "0" => {
        "name" => "Kan gurubu",
        "selections_attributes" => {
          "0" => { "label" => "0" },
          "1" => { "label" => "A" },
          "2" => { "label" => "B" },
          "3" => { "label" => "AB" }
        }
      },
      "1" => {
        "name" => "RH",
        "selections_attributes" => {
          "0" => { "label" => "RH+" },
          "1" => { "label" => "RH-" }
        }
      }
    },
    "service_price_attributes"  => {
      "sender_credit"   => "0",
      "receiver_credit" => "0"
    }
  }
  Service.create(service)

  service = {
    "title"              => "Devlet kurumlari memur ilanlari",
    "description"        => Faker::Lorem.paragraph(5),
    "filters_attributes"  => {
      "0" => {
        "name" => "Bolum",
        "selections_attributes" => {
          "0" => { "label" => "Bilgisayar Muhendisligi" },
          "1" => { "label" => "Elektrik Elektronik Muhendisligi" },
          "2" => { "label" => "Makine Muhendisligi" },
          "3" => { "label" => "Insaat Muhendisligi" },
          "4" => { "label" => "Mimarlik" },
          "5" => { "label" => "Jeoloji Muhendisligi" },
          "6" => { "label" => "Ziraat Muhendisligi" },
          "7" => { "label" => "Seramik Muhendisligi" },
          "8" => { "label" => "Metalurji Muhendisligi" }
        }
      }
    },
    "service_price_attributes"  => {
      "sender_credit"   => "0",
      "receiver_credit" => "2"
    }
  }
  Service.create(service)

  Service.populate 10 do |service|
    service.title       = Populator.words(2..5).titleize
    service.description = Faker::Lorem.paragraph
    puts service
    Filter.populate 0..3 do |filter|
      filter.service_id = service.id
      filter.name       = Populator.words(1..3).titleize
      puts filter
      Selection.populate 3..20 do |selection|
        selection.filter_id = filter.id
        selection.label     = Populator.words(1..3).titleize
        puts selection
      end
    end
    ServicePrice.populate 1 do |price|
      price.service_id = service.id
      price.receiver_credit = 0..10
      price.sender_credit = 0..10
      puts price
    end
  end
end

def make_subscriptions
  Account.limit(10).each do |account|
    Service.all.each do |service|
      subscription = Subscription.create(
        :account => account,
        :service => service,
        :selection_ids => selection_ids(service)
      )
      puts subscription
    end
  end
end

def make_notifications
  Service.all.each do |service|
    Random.new.rand(5..10).times do
      array = selection_ids(service)
      puts array.to_s
      notification = service.notifications.create(
        :title => Populator.words(2..5).titleize,
        :description => Faker::Lorem.paragraphs(5).join("<br /><br />"),
        :sms => Faker::Lorem.paragraph.truncate(150),
        :selection_ids => array,
        :available_until => Date.today + Random.new.rand(-10..10),
        :notificationable => Account.find(Random.new.rand(Account.first.id..Account.last.id))
      )

      notification.update_attributes(
        :published => true,
        :published_at => Time.now
      )
      puts notification
    end
  end
end

def selection_ids(service)
  array = []

  service.filters.each do |filter|
    selections_count = filter.selections.count
    array2 = []
    filter.selections.each { |selection| array2 << selection.id }
    array3 = []
    random = Random.new.rand(1..selections_count)
    random.times do |i|
      array3 << array2[i]
    end

    array += array3
  end

  return array.uniq
end