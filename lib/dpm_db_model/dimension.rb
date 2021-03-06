# frozen_string_literal: true

module DpmDbModel

  class Dimension < Sequel::Model(:mDimension)

    many_to_one :concept, class: 'DpmDbModel::Concept', key: :ConceptID, primary_key: :ConceptID, read_only: true
    many_to_one :domain, class: 'DpmDbModel::Domain', key: :DomainID, primary_key: :DomainID, read_only: true

    dataset_module do
      def explicit()
        where(IsTypedDimension: false)
      end

      def typed()
        where(IsTypedDimension: true)
      end

      def notMet()
        exclude(DimensionCode: 'MET')
      end

      def for_owner(owner)
        association_join(:concept).where(OwnerId: owner.OwnerID)
      end

      def all_sorted_naturally_by_dimcode
        Naturally.sort(all(), by: :DimensionCode)
      end
    end
  end
end
