class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable
  has_one :payment
  accepts_nested_attributes_for :payment
  # Nested attributes allow you to save attributes on associated records through the parent (here it's User). 
  # By default nested attribute updating is turned off and you can enable it using the 
  # accepts_nested_attributes_for class method. When you enable nested attributes an attribute writer 
  # is defined on the model.
  # The attribute writer is named after the association, which means that in the following example, 
  # two new methods are added to your model:
  # user_attributes=(attributes) and payment_attributes=(attributes)
  # Enabling nested attributes on a one-to-one association allows you to create the member and avatar in one go:
end
