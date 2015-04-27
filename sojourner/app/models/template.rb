# The Climate Corporation licenses this file to you under under the Apache
# License, Version 2.0 (the "License"); you may not use this file except in
# compliance with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# See the NOTICE file distributed with this work for additional information
# regarding copyright ownership.  Unless required by applicable law or agreed
# to in writing, software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express
# or implied.  See the License for the specific language governing permissions
# and limitations under the License.
class Template < ActiveRecord::Base
  validates :name, :type, :created_by, presence: true

  scope :singles, -> { where(type: 'TemplateSingle') }
  scope :bundles, -> { where(type: 'TemplateBundle') }

  def version(*args)
    begin
      version!(*args)
    rescue ActiveRecord::RecordNotFound
      nil
    end
  end

  def version!(num_or_opts = {})
    return version_from_options(num_or_opts) if num_or_opts.is_a?(Hash)

    versions.find_by_version(num_or_opts).tap do |v|
      if v.nil?
        raise ActiveRecord::RecordNotFound, "not found for version #{num_or_opts}"
      end
    end
  end

  def versions
    raise "The subclass needs to have an implementation of this"
  end

  private

  def version_from_options(opts = {})
    raise "The subclass needs to have an implementation of this"
  end
end
