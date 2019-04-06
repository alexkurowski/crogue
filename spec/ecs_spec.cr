require "./spec_helper"

describe ECS do
  it "spawns an entity" do
    ecs = ECS.new
    entity = ecs.spawn test: true

    entity.should be_a Entity
  end

  it "can iterate over entities" do
    ecs = ECS.new
    ecs.spawn test: true
    ecs.spawn test: true

    iter_count = 0
    ecs.each do |components|
      components[:test].should be_true
      iter_count += 1
    end
    iter_count.should eq 2
  end

  it "can iterate over filtered entities" do
    ecs = ECS.new
    ecs.spawn position: Component::Position.new
    ecs.spawn test: true

    iter_count = 0
    ecs.each :position do |components|
      components[:position].should be_truthy
      iter_count += 1
    end
    iter_count.should eq 1
  end

  it "can retrieve typed component" do
    ecs = ECS.new
    entity = ecs.spawn position: Component::Position.new
    components = ecs.components[entity]

    components.get_position.should be_a Component::Position
  end

  it "can find entity components" do
    ecs = ECS.new
    ecs.spawn test: true
    ecs.spawn test: true
    player = ecs.spawn player: true

    components = ecs.find :player
    components[:player].should be_true
    components.has_key?(:test).should be_false

    entity = ecs.find_index :player
    entity.should eq player
  end
end
