require 'rails_helper'

RSpec.describe Project, type: :model do
  it 'requires a name' do
    project = Project.new(:name => '')
    project.valid?
    expect(project.errors[:name].any?).to eq true
  end
end
