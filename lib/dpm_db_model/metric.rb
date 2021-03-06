# frozen_string_literal: true

module DpmDbModel

  class Metric < Sequel::Model(:mMetric)

    many_to_one :corresponding_member, class: 'DpmDbModel::Member', key: :CorrespondingMemberID, primary_key: :MemberID, read_only: true
    many_to_one :referenced_domain, class: 'DpmDbModel::Domain', key: :ReferencedDomainID, primary_key: :DomainID, read_only: true
    many_to_one :referenced_hierarchy, class: 'DpmDbModel::Hierarchy', key: :ReferencedHierarchyID, primary_key: :HierarchyID, read_only: true

    def corresponding_member_code_number
      corresponding_member.code_number
    end

    dataset_module do
      def for_owner(owner)
        association_join(corresponding_member: :concept).where(OwnerId: owner.OwnerID)
      end

      def all_sorted_naturally_by_member_code_number
        Naturally.sort(all(), by: :corresponding_member_code_number)
      end

    end
  end
end
