# frozen_string_literal: true

module DpmDbModel

  class Hierarchy < Sequel::Model(:mHierarchy)

    many_to_one :concept, class: 'DpmDbModel::Concept', key: :ConceptID, primary_key: :ConceptID, read_only: true

    dataset_module do
      def for_domain(domain)
        where(DomainID: domain.DomainID)
      end

      def for_domain_and_owner(domain, owner)
        where(DomainID: domain.DomainID).association_join(:concept).where(OwnerId: owner.OwnerID)
      end

      def all_sorted_naturally_by_hiercode
        Naturally.sort(all(), by: :HierarchyCode)
      end
    end
  end

end
