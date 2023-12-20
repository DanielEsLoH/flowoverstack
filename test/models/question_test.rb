# == Schema Information
#
# Table name: questions
#
#  id          :bigint           not null, primary key
#  title       :string
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :bigint           not null
#
require 'test_helper'

class QuestionTest < ActiveSupport::TestCase

end
