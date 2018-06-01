
FactoryBot.define do
  #User_spec
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
  
  #Micropost_spec
   factory :most_recent, class: Micropost do
    
    content "Writing a short test"
    created_at Time.zone.now
    user User.first
   end
   
   #relationships_controller_spec
   factory :one, class: Relationship do
    follower :michael
    followed :lana
   end
   
   #microposts_controller_spec
   factory :orange, class: Micropost do
    content "I just ate an orange!"
    created_at 10.minutes.ago
    user User.first
   end
  
   factory :ants, class: Micropost do
    content "Oh, is that what you want? Because that's how you get ants!"
    created_at 2.years.ago
    user User.second
   end
  
end