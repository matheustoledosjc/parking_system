FactoryBot.define do
  factory :parking do
    plate { "#{('a'..'z').to_a.sample(3).join}-#{(0..9).to_a.sample(4).join}" }

    trait :paid do
      paid_at { (1..9).to_a.sample.hours.from_now }
    end

    trait :left do
      paid_at { (1..9).to_a.sample.hours.from_now }
      left_at { 10.hours.from_now }
    end
  end
end
