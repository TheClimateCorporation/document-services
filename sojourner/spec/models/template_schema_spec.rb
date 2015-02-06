require 'rails_helper'

RSpec.describe TemplateSchema, :type => :model do
  it { is_expected.to validate_presence_of(:name) }

  let(:schema_properties) { {root: {type: 'object'}} }

  it { is_expected.to validate_presence_of(:json_schema_properties) }

  it "ensures that json_schema_properties is a valid json string" do
    is_expected.to allow_value(schema_properties.to_json).for(:json_schema_properties)
    is_expected.not_to allow_value('just a string').for(:json_schema_properties)
  end

  it "ensures json_schema_properties defines valid json schema properties" do
    schema_properties[:root][:description] = "a string"
    is_expected.to allow_value(schema_properties.to_json).for(:json_schema_properties)

    # Description should be a string
    schema_properties[:root][:description] = 1
    is_expected.not_to allow_value(schema_properties.to_json).for(:json_schema_properties)
  end

  it "ensures that json_schema_properties don't include 'id' attributes" do
    schema_properties[:root][:id] = "#"
    is_expected.not_to allow_value(schema_properties.to_json).for(:json_schema_properties)
  end

  it "ensures a root element is included in the json_schema_properties" do
    # Disallow properties without a root element
    is_expected.to_not allow_value({}.to_json).for(:json_schema_properties)

    # Disallow properties with multiple root elements
    schema_properties[:another_root] = schema_properties[:root].dup
    is_expected.to_not allow_value(schema_properties.to_json).for(:json_schema_properties)
  end

  it { is_expected.to validate_presence_of(:json_stub) }
  context "when json_schema_properties is valid" do
    before { subject.json_schema_properties = schema_properties.to_json }

    it "ensures that json_stub is a valid json string" do
      is_expected.to allow_value('{"root": {}}').for(:json_stub)
      is_expected.not_to allow_value('a').for(:json_stub)
    end

    it "ensures that json_stub complies to schema_stub" do
      is_expected.to allow_value('{"root": {}}').for(:json_stub)
      is_expected.not_to allow_value('{"root": false}').for(:json_stub)
    end
  end

  context "when json_schema_properties is invalid" do
    it "does not validate json_stub format" do
      is_expected.to allow_value('{}').for(:json_stub)
      is_expected.to allow_value('a').for(:json_stub)
    end
  end

  it { is_expected.to validate_presence_of(:created_by) }

  describe "self.new_clone" do
    it "copies the json_schema_properties and the json_stub" do
      new_schema = TemplateSchema.new_clone(subject)

      expect(new_schema).to be_an_instance_of(TemplateSchema)
      expect(new_schema.json_schema_properties).to eq(subject.json_schema_properties)
      expect(new_schema.json_stub).to eq(subject.json_stub)
    end
  end

  describe "#json_schema" do
    let(:template_schema) { build(:template_schema, json_schema_properties: schema_properties.to_json) }

    it "disallows additional root elements" do
      expect(
        JSON::Validator.fully_validate(
          template_schema.json_schema,
          {root: {}, extra_root: {}}
        )
      ).to include(/contains additional properties/)
    end

    it "makes json_schema_properties root element required" do
      expect(
        JSON::Validator.fully_validate(template_schema.json_schema, {})
      ).to include(/required/)
    end

    it "adds json_schema_properties as the schema properties" do
      schema = MultiJson.load(template_schema.json_schema, symbolize_keys: true)
      expect(schema[:properties]).to eq(schema_properties)
    end
  end

  describe "#immutable?" do
    context "when assigned to template_single_version" do
      it "returns true" do
        template_schema = create(:template_schema)
        create(:template_single_version, template_schema: template_schema)

        expect(template_schema.immutable?).to be(true)
      end
    end

    context "when not assigned to template_single_version" do
      it "returns false" do
        template_schema = create(:template_schema)

        # Guard assertion
        expect(template_schema.template_single_versions).to be_empty

        expect(template_schema.immutable?).to be(false)
      end
    end
  end

  it "soft deletes entries" do
    template_schema = create(:template_schema)
    template_schema.destroy

    expect {
      TemplateSchema.with_deleted.find(template_schema.id)
    }.to_not raise_error
  end
end
