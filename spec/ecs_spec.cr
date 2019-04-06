require "./spec_helper"

describe ECS do
  it "spawns an entity" do
    ecs = ECS.new
    entity = ecs.spawn(
      test: true
    )
    entity.should be_a Entity
  end

  it "can iterate over entities" do
    ecs = ECS.new
    ecs.spawn(test: true)
    ecs.spawn(test: true)

    iter_count = 0
    ecs.each_entity do |components|
      components[:test].should be_truthy
      iter_count += 1
    end
    iter_count.should eq 2
  end

  it "can iterate over filtered entities" do
    ecs = ECS.new
    ecs.spawn(position: Component::Position.new)
    ecs.spawn(test: true)

    iter_count = 0
    ecs.each_entity(:position) do |components|
      components[:position].should be_truthy
      iter_count += 1
    end
    iter_count.should eq 1
  end
end
