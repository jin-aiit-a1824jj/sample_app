
FactoryBot.define do
  
  factory :michael, class: User do
    
    name "Michael Example"
    email "michael1@example.com"
    password_digest User.digest('password')
    admin true
    activated true
    activated_at Time.zone.now
  end
  
  factory :archer, class: User do
    
    name "Sterling Archer"
    email "duchess1@example.gov"
    password_digest User.digest('password')
    activated true
    activated_at Time.zone.now
  end
 
  factory :lana, class: User do
    
    name "Lana Kane"
    email "hands1@example.gov"
    password_digest User.digest('password')
    activated true
    activated_at Time.zone.now
  end
  
end