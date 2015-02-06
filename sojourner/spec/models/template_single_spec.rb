require 'rails_helper'

RSpec.describe TemplateSingle, type: :model do
  describe "#version!" do
    context "when options are passed as param" do
      let(:template) { create(:template, :single) }

      it "ensures schema_id is given" do
        expect {
          template.version!({})
        }.to raise_error(ArgumentError)
      end

      context "when versions exist for the given schema_id" do
        it "returns the lastest version for the given schema_id" do
          template_schema = create(:template_schema)

          # old and expected
          versions = create_list(:template_single_version, 2,
                                 template_schema: template_schema, template: template)

          # latter version but with different schema
          create(:template_single_version,
                 template_schema: create(:template_schema), template: template)

          lastest_version = versions.last
          expect(template.version!(schema_id: template_schema.id))
            .to eq(lastest_version)
        end
      end

      context "when no versions exist for the given schema_id" do
        it "raises a not found error" do
          expect {
            template.version!(schema_id: 9999)
          }.to raise_error(
            ActiveRecord::RecordNotFound,
            "doesn't exist for schema_id 9999"
          )
        end
      end

      context "when a template version exists for the given version" do
        context "when version matches the given schema_id" do
          it "returns the template version for the given version" do
            # prior, expected and latter
            versions = create_list(:template_single_version, 3, template: template)

            expected_version = versions[1]
            expect(template.version(
              schema_id: expected_version.template_schema_id,
              version: expected_version.version
            )).to eq(expected_version)
          end
        end

        context "when the version doesn't match the schema_id" do
          it "raises a not found error" do
            expected_version = create(:template_single_version, template: template)
            other_version = create(:template_single_version, template: template)

            expect { template.version!(
              schema_id: other_version.template_schema_id,
              version: expected_version.version
            ) }.to raise_error(
              ActiveRecord::RecordNotFound,
              "doesn't exist for version #{expected_version.version} and schema_id #{other_version.template_schema_id}"
            )
          end
        end
      end

      context "when a template version doesn't exist for the given version" do
        it "raises a not found error" do
          version = create(:template_single_version, template: template)

          expect { template.version!(
            schema_id: version.template_schema_id,
            version: 9999
          ) }.to raise_error(
            ActiveRecord::RecordNotFound,
            "doesn't exist for version 9999"
          )
        end
      end

      context "when as_production opt is true" do
        context "when versions are available for production" do
          it "returns the lastest enabled for production version" do
            schema = create(:template_schema)

            # old and expected
            versions = create_list(:template_single_version, 2,
              template: template, template_schema: schema, ready_for_prod: true)

            # latter but not enabled for prod
            create(:template_single_version, template: template,
              template_schema: schema, ready_for_prod: false)

            expected_version = versions.last
            expect(
              template.version!(schema_id: schema.id, as_production: true)
            ).to eq(expected_version)
          end

          context "when a version enabled for production is unavailable" do
            it "raises a not found error" do
              version = create(:template_single_version, template: template,
                ready_for_prod: false)
              expect { template.version!(
                schema_id: version.template_schema_id,
                as_production: true
              ) }.to raise_error(
                ActiveRecord::RecordNotFound,
                "is not available in production"
              )
            end
          end
        end
      end
    end
  end
end
