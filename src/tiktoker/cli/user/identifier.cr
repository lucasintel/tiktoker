class TikToker::CLI
  class User
    module Identifier
      DELIMITER = ':'

      TYPE_POS = 0
      NAME_POS = 1

      class InvalidIdentifierError < Exception
      end

      abstract struct BaseIdentifier
        getter name : String

        def initialize(@name)
        end
      end

      {% for type, _index in %w[Username SecUID ID] %}
        {{type.id.upcase}}_TYPE = {{type.downcase}}

        struct {{type.id}} < BaseIdentifier
        end
      {% end %}

      def self.for(string : String) : BaseIdentifier
        candidate = string.split(DELIMITER, remove_empty: true, limit: 2)
        candidate.unshift(USERNAME_TYPE) if candidate.one?

        if candidate.empty? || candidate[NAME_POS].blank?
          raise InvalidIdentifierError.new("User identifier cannot be blank!")
        end

        klass =
          case candidate[TYPE_POS].downcase
          when USERNAME_TYPE
            Identifier::Username
          when SECUID_TYPE
            Identifier::SecUID
          when ID_TYPE
            Identifier::ID
          else
            raise InvalidIdentifierError
              .new("Unrecognized identifier type: #{candidate[TYPE_POS]}!")
          end

        klass.new(candidate[NAME_POS])
      end
    end
  end
end
