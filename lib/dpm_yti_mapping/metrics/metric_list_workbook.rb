# frozen_string_literal: true

module DpmYtiMapping

  class Metrics

    class MetricsListWorkbook

      def self.generate_workbook(metrics, metric_hierarchies)
        sheets = [
          codescheme_sd(),
          codes_sd(metrics),
          metric_extensions_sd(metric_hierarchies),
          metric_extension_members_sd(metrics)
        ]

        metric_hierarchies.map do |hierarchy_item|
          sheets << metric_hierarchy_extension_members_sd(hierarchy_item)
        end

        WorkbookModel::WorkbookData.new(
          "#{YtiRds::Constants.versioned_code('metrics')}",
          sheets
        )
      end

      private

      def self.codescheme_sd
        row_data = {
          ID: SecureRandom.uuid,
          CODEVALUE: YtiRds::Constants.versioned_code('metrics'),
          INFORMATIONDOMAIN: YtiRds::Constants::INFORMATION_DOMAIN,
          LANGUAGECODE: YtiRds::Constants::LANGUAGE_CODE,
          STATUS: YtiRds::Constants::STATUS,
          DEFAULTCODE: nil,
          PREFLABEL_FI: YtiRds::Constants.versioned_label('Metrics'),
          PREFLABEL_EN: nil,
          DESCRIPTION_FI: 'Lista Metriceistä.',
          DESCRIPTION_EN: nil,
          STARTDATE: nil,
          ENDDATE: nil,
          CODESSHEET: YtiRds::Sheets.codes_name,
          EXTENSIONSSHEET: YtiRds::Sheets.extensions_name
        }

        WorkbookModel::SheetData.new(
          YtiRds::Sheets.codescheme_name,
          YtiRds::Sheets.codescheme_columns,
          [row_data]
        )
      end

      def self.codes_sd(metrics)
        rows = metrics.map do |met|
          {
            ID: SecureRandom.uuid,
            CODEVALUE: met.corresponding_member.code_number,
            BROADER: nil,
            STATUS: YtiRds::Constants::STATUS,
            PREFLABEL_FI: met.corresponding_member.concept.label_fi,
            PREFLABEL_EN: met.corresponding_member.concept.label_en,
            DESCRIPTION_FI: met.corresponding_member.concept.description_fi,
            DESCRIPTION_EN: met.corresponding_member.concept.description_en,
            STARTDATE: met.corresponding_member.concept.start_date_iso8601,
            ENDDATE: met.corresponding_member.concept.end_date_iso8601
          }
        end

        WorkbookModel::SheetData.new(
          YtiRds::Sheets.codes_name,
          YtiRds::Sheets.codes_columns,
          rows
        )
      end

      def self.metric_extensions_sd(metric_hierarchies)
        dpm_metric_row = {
          ID: SecureRandom.uuid,
          CODEVALUE: YtiRds::Constants::ExtensionTypes::DPM_METRIC,
          STATUS: YtiRds::Constants::STATUS,
          PROPERTYTYPE: YtiRds::Constants::ExtensionTypes::DPM_METRIC,
          PREFLABEL_FI: nil,
          PREFLABEL_EN: nil,
          STARTDATE: nil,
          ENDDATE: nil,
          MEMBERSSHEET: YtiRds::Sheets.extension_members_name(
            YtiRds::Constants::ExtensionTypes::DPM_METRIC
          )
        }

        rows = [dpm_metric_row] + metric_hierarchies.map do |hierarchy_item|

          h = hierarchy_item.hierarchy

          {
            ID: SecureRandom.uuid,
            CODEVALUE: h.HierarchyCode,
            STATUS: YtiRds::Constants::STATUS,
            PROPERTYTYPE: YtiRds::Constants::ExtensionTypes::DEFINITION_HIERARCHY,
            PREFLABEL_FI: h.concept.label_fi,
            PREFLABEL_EN: h.concept.label_en,
            STARTDATE: h.concept.start_date_iso8601,
            ENDDATE: h.concept.end_date_iso8601,
            MEMBERSSHEET: YtiRds::Sheets.extension_members_name(h.HierarchyCode)
          }
        end

        WorkbookModel::SheetData.new(
          YtiRds::Sheets.extensions_name,
          YtiRds::Sheets.extensions_columns,
          rows
        )
      end

      def self.metric_extension_members_sd(metrics)

        rows = metrics.map do |met|
          {
            ID: SecureRandom.uuid,
            CODE: met.corresponding_member_code_number,
            DPMMETRICDATATYPE: dpm_metric_data_type_to_yti(met.DataType),
            DPMFLOWTYPE: dpm_metric_flow_type_to_yti(met.FlowType),
            DPMBALANCETYPE: dpm_metric_balance_type_to_yti(met.BalanceType),
            DPMDOMAINREFERENCE: met.referenced_domain ? met.referenced_domain.DomainCode : nil,
            DPMHIERARCHYREFERENCE: met.referenced_hierarchy ? met.referenced_hierarchy.HierarchyCode : nil
          }
        end

        WorkbookModel::SheetData.new(
          YtiRds::Sheets.extension_members_name(YtiRds::Constants::ExtensionTypes::DPM_METRIC),
          YtiRds::Sheets.extension_members_columns(YtiRds::Constants::ExtensionTypes::DPM_METRIC),
          rows
        )
      end

      def self.dpm_metric_data_type_to_yti(dpm_data_type)
        mapping = {
          'Enumeration/Code' => 'Enumeration',
          'Boolean' => 'Boolean',
          'Date' => 'Date',
          'Integer' => 'Integer',
          'Monetary' => 'Monetary',
          'Percent' => 'Percentage',
          'String' => 'String',
          'Decimal' => 'Decimal',
          'Lei' => 'Lei',
          'Isin' => 'Isin'
        }

        yti_value = mapping[dpm_data_type]

        if !mapping.key?(dpm_data_type) || yti_value.nil?
          raise("Unsupported DPM Metric data type: [#{dpm_data_type}]")
        end

        yti_value
      end

      def self.dpm_metric_flow_type_to_yti(dpm_flow_type)
        return nil if dpm_flow_type.nil?

        mapping = {
          'Stock' => 'Instant',
          'Flow' => 'Duration'
        }

        yti_value = mapping[dpm_flow_type]

        if !mapping.key?(dpm_flow_type) || yti_value.nil?
          raise("Unsupported DPM Metric flow type: [#{dpm_flow_type}]")
        end

        yti_value
      end

      def self.dpm_metric_balance_type_to_yti(dpm_balance_type)
        return nil if dpm_balance_type.nil?

        unless ['Credit', 'Debit'].include?(dpm_balance_type)
          raise("Unsupported DPM Metric balance type: [#{dpm_balance_type}]")
        end

        dpm_balance_type
      end

      def self.metric_hierarchy_extension_members_sd(hierarchy_item)
        h = hierarchy_item.hierarchy

        rows = hierarchy_item.nodes.map do |hn|

          row = {
            ID: SecureRandom.uuid,
            CODE: hn.member.code_number,
            RELATION: hn.parent_member.nil? ? nil : "code:#{hn.parent_member.code_number}",
            PREFLABEL_FI: hn.concept.label_fi,
            PREFLABEL_EN: hn.concept.label_en,
            STARTDATE: hn.concept.start_date_iso8601,
            ENDDATE: hn.concept.end_date_iso8601
          }

          row
        end

        WorkbookModel::SheetData.new(
          YtiRds::Sheets.extension_members_name(h.HierarchyCode),
          YtiRds::Sheets.extension_members_columns(YtiRds::Constants::ExtensionTypes::DEFINITION_HIERARCHY),
          rows
        )
      end
    end
  end
end
