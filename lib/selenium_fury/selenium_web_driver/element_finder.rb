#/* Copyright (c) 2010 HomeAway, Inc.
# * All rights reserved.  http://www.homeaway.com
# *
# * Licensed under the Apache License, Version 2.0 (the "License");
# * you may not use this file except in compliance with the License.
# * You may obtain a copy of the License at
# *
# *      http://www.apache.org/licenses/LICENSE-2.0
# *
# * Unless required by applicable law or agreed to in writing, software
# * distributed under the License is distributed on an "AS IS" BASIS,
# * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# * See the License for the specific language governing permissions and
# * limitations under the License.
# */
module SeleniumFury
  module SeleniumWebDriver
    class ElementFinder
      def initialize (nokogiri_elements)
        @nokogiri_elements=nokogiri_elements
        @valid_locators=["id", "class", "name"]
      end

      attr_reader :nokogiri_elements, :valid_locators

      def find_elements
        locators=[]
        nokogiri_elements.each do |nokogiri_element|
          valid_locators.each do |valid_locator|
            if nokogiri_element.get_attribute(valid_locator) != nil
              locators.push({valid_locator.to_sym => nokogiri_element.get_attribute(valid_locator)})
              break
            end
          end
        end
        return locators
      end

      def web_driver_page_object_attributes
        locators=find_elements
        generated_attributes ={}
        locators.each do |locator|
          cleaned_name=clean_attribute_name(locator.values[0])
          generated_attributes[cleaned_name] = locator
        end
        return generated_attributes
      end

      def clean_attribute_name name
        if !name.nil?
          find_and_replace_patterns = [[/([A-Z]+)/, '_\1'],
                                       ['input-', ''],
                                       ['select-', ''],
                                       ['\\', ''],
                                       [' ', '_'],
                                       ['.', '_'],
                                       ['-', '_'],
                                       ['__', '_']
          ]
          find_and_replace_patterns.each do |pattern|
            name=name.gsub(pattern[0], pattern[1])
          end
          name=name.to_s.downcase
        end
        return name
      end
    end
  end
end