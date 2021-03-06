require 'rspec'

RSpec.describe DpmYtiMapping::Metrics do

  let(:owner) { DpmDbModel::Owner.by_name('Suomi SBR') }
  let(:workbooks) { DpmYtiMapping::Metrics.generate_workbooks(owner) }

  it 'should produce total 1 workbook' do
    expect(workbooks.length).to eq(1)
  end

  context 'Workbook: metrics' do
    let(:workbook_name) { 'metrics-2018-1' }

    it 'should have 7 sheets' do
      expect_each_sheet(workbooks, workbook_name, 7) do |sheet, index|
        expect(sheet).to be_an_instance_of(WorkbookModel::SheetData)

        case index
        when 0
          expect(sheet.sheet_name).to eq('CodeSchemes')
        when 1
          expect(sheet.sheet_name).to eq('Codes')
        when 2
          expect(sheet.sheet_name).to eq('Extensions')
        when 3
          expect(sheet.sheet_name).to eq('Members_dpmMetric')
        when 4
          expect(sheet.sheet_name).to eq('Members_MET1')
        when 5
          expect(sheet.sheet_name).to eq('Members_MET10')
        when 6
          expect(sheet.sheet_name).to eq('Members_METHIER')
        end
      end
    end

    it 'Sheet 1/7: CodeSchemes' do
      expect_each_row(workbooks, workbook_name, 'CodeSchemes', 1) do |row, index|
        expect(row).to be_an_instance_of(Hash)

        case index
        when 0
          expect(row[:ID].length).to eq(36)
          expect(row[:INFORMATIONDOMAIN]).to eq('P14')
          expect(row[:LANGUAGECODE]).to eq('fi;sv;en')
          expect(row[:STATUS]).to eq('DRAFT')
          expect(row[:CODEVALUE]).to eq('metrics-2018-1')
          expect(row[:DEFAULTCODE]).to be_nil
          expect(row[:PREFLABEL_FI]).to eq('Metrics 2018-1')
          expect(row[:PREFLABEL_EN]).to be_nil
          expect(row[:DESCRIPTION_FI]).to start_with('Lista Metriceistä')
          expect(row[:DESCRIPTION_EN]).to be_nil
          expect(row[:STARTDATE]).to be_nil
          expect(row[:ENDDATE]).to be_nil
          expect(row[:CODESSHEET]).to eq('Codes')
          expect(row[:EXTENSIONSSHEET]).to eq('Extensions')

          expect(row.length).to eq(14)
        end
      end
    end

    it 'Sheet 2/7: Codes' do
      expect_each_row(workbooks, workbook_name, 'Codes', 13) do |row, index|
        expect(row).to be_an_instance_of(Hash)

        case index
        when 0
          expect(row[:ID].length).to eq(36)
          expect(row[:STATUS]).to eq('DRAFT')
          expect(row[:CODEVALUE]).to eq('1')
          expect(row[:BROADER]).to be_nil
          expect(row[:PREFLABEL_FI]).to eq('Metric member (fi, label)')
          expect(row[:PREFLABEL_EN]).to be_nil
          expect(row[:DESCRIPTION_FI]).to eq('Metric member (fi, description)')
          expect(row[:DESCRIPTION_EN]).to be_nil
          expect(row[:STARTDATE]).to eq('2018-10-31') # DM issue: date is written wrongly to DB
          expect(row[:ENDDATE]).to be_nil
          expect(row.length).to eq(10)

        when 1
          expect(row[:PREFLABEL_FI]).to eq('MET member (Enumeration: EDA)')
          expect(row[:CODEVALUE]).to eq('3')

        when 2
          expect(row[:ID].length).to eq(36)
          expect(row[:STATUS]).to eq('DRAFT')
          expect(row[:CODEVALUE]).to eq('4')
          expect(row[:BROADER]).to be_nil
          expect(row[:PREFLABEL_FI]).to eq('MET member (Boolean)')
          expect(row[:PREFLABEL_EN]).to be_nil
          expect(row[:DESCRIPTION_FI]).to eq('')
          expect(row[:DESCRIPTION_EN]).to be_nil
          expect(row[:STARTDATE]).to eq('2018-10-31') # DM issue: date is written wrongly to DB
          expect(row[:ENDDATE]).to be_nil
          expect(row.length).to eq(10)

        when 3
          expect(row[:PREFLABEL_FI]).to eq('MET member (Integer)')
          expect(row[:CODEVALUE]).to eq('6')

        when 4
          expect(row[:PREFLABEL_FI]).to eq('MET member (Monetary)')
          expect(row[:CODEVALUE]).to eq('7')

        when 5
          expect(row[:PREFLABEL_FI]).to eq('MET member (Percentage)')
          expect(row[:CODEVALUE]).to eq('8')

        when 6
          expect(row[:PREFLABEL_FI]).to eq('MET member (String)')
          expect(row[:CODEVALUE]).to eq('9')

        when 7
          expect(row[:PREFLABEL_FI]).to eq('MET member (Decimal)')
          expect(row[:CODEVALUE]).to eq('10')

        when 8
          expect(row[:PREFLABEL_FI]).to eq('MET member (Lei)')
          expect(row[:CODEVALUE]).to eq('11')

        when 9
          expect(row[:PREFLABEL_FI]).to eq('MET member (Isin)')
          expect(row[:CODEVALUE]).to eq('12')

        when 10
          expect(row[:PREFLABEL_FI]).to eq('MET member (String, Instant, Credit)')
          expect(row[:CODEVALUE]).to eq('13')

        when 11
          expect(row[:PREFLABEL_FI]).to eq('MET member (String, Duration, Debit)')
          expect(row[:CODEVALUE]).to eq('14')

        when 12
          expect(row[:PREFLABEL_FI]).to eq('MET member (Date)')
          expect(row[:CODEVALUE]).to eq('16')

        end
      end
    end

    it 'Sheet 3/7: Extensions' do
      expect_each_row(workbooks, workbook_name, 'Extensions', 4) do |row, index|
        expect(row).to be_an_instance_of(Hash)

        case index
        when 0
          expect(row[:ID].length).to eq(36)
          expect(row[:CODEVALUE]).to eq('dpmMetric')
          expect(row[:STATUS]).to eq('DRAFT')
          expect(row[:PROPERTYTYPE]).to eq('dpmMetric')
          expect(row[:PREFLABEL_FI]).to be_nil
          expect(row[:PREFLABEL_EN]).to be_nil
          expect(row[:STARTDATE]).to be_nil
          expect(row[:ENDDATE]).to be_nil
          expect(row[:MEMBERSSHEET]).to eq('Members_dpmMetric')
          expect(row.length).to eq(9)

        when 1
          expect(row[:ID].length).to eq(36)
          expect(row[:CODEVALUE]).to eq('MET1')
          expect(row[:PROPERTYTYPE]).to eq('definitionHierarchy')
          expect(row[:PREFLABEL_FI]).to eq('Metric hierarchy 1')
          expect(row[:PREFLABEL_EN]).to be_nil
          expect(row[:STARTDATE]).to eq('2018-10-31') # DM issue: date is written wrongly to DB
          expect(row[:ENDDATE]).to be_nil
          expect(row[:MEMBERSSHEET]).to eq('Members_MET1')
          expect(row.length).to eq(9)

        when 2
          expect(row[:ID].length).to eq(36)
          expect(row[:CODEVALUE]).to eq('MET10')
          expect(row[:PROPERTYTYPE]).to eq('definitionHierarchy')
          expect(row[:PREFLABEL_FI]).to eq('Metric hierarchy 10')
          expect(row[:PREFLABEL_EN]).to be_nil
          expect(row[:STARTDATE]).to eq('2018-10-31') # DM issue: date is written wrongly to DB
          expect(row[:ENDDATE]).to be_nil
          expect(row[:MEMBERSSHEET]).to eq('Members_MET10')
          expect(row.length).to eq(9)

        when 3
          expect(row[:ID].length).to eq(36)
          expect(row[:CODEVALUE]).to eq('METHIER')
          expect(row[:PROPERTYTYPE]).to eq('definitionHierarchy')
          expect(row[:PREFLABEL_FI]).to eq('Metric hierarchy (fi, label)')
          expect(row[:PREFLABEL_EN]).to be_nil
          expect(row[:STARTDATE]).to eq('2018-10-31') # DM issue: date is written wrongly to DB
          expect(row[:ENDDATE]).to be_nil
          expect(row[:MEMBERSSHEET]).to eq('Members_METHIER')
          expect(row.length).to eq(9)
        end
      end
    end

    it 'Sheet 4/7: Members_dpmMetric' do
      expect_each_row(workbooks, workbook_name, 'Members_dpmMetric', 13) do |row, index|
        expect(row).to be_an_instance_of(Hash)

        case index
        when 0
          expect(row[:ID].length).to eq(36)
          expect(row[:CODE]).to eq('1')
          expect(row[:DPMMETRICDATATYPE]).to eq('Boolean')
          expect(row[:DPMFLOWTYPE]).to be_nil
          expect(row[:DPMBALANCETYPE]).to be_nil
          expect(row[:DPMDOMAINREFERENCE]).to be_nil
          expect(row[:DPMHIERARCHYREFERENCE]).to be_nil
          expect(row.length).to eq(7)

        when 1
          expect(row[:CODE]).to eq('3')
          expect(row[:DPMMETRICDATATYPE]).to eq('Enumeration')
          expect(row[:DPMFLOWTYPE]).to be_nil
          expect(row[:DPMBALANCETYPE]).to be_nil
          expect(row[:DPMDOMAINREFERENCE]).to eq('EDA')
          expect(row[:DPMHIERARCHYREFERENCE]).to eq('EDA-H1')

        when 2
          expect(row[:ID].length).to eq(36)
          expect(row[:CODE]).to eq('4')
          expect(row[:DPMMETRICDATATYPE]).to eq('Boolean')
          expect(row[:DPMFLOWTYPE]).to be_nil
          expect(row[:DPMBALANCETYPE]).to be_nil
          expect(row[:DPMDOMAINREFERENCE]).to be_nil
          expect(row[:DPMHIERARCHYREFERENCE]).to be_nil
          expect(row.length).to eq(7)

        when 3
          expect(row[:CODE]).to eq('6')
          expect(row[:DPMMETRICDATATYPE]).to eq('Integer')
          expect(row[:DPMFLOWTYPE]).to be_nil
          expect(row[:DPMBALANCETYPE]).to be_nil
          expect(row[:DPMDOMAINREFERENCE]).to be_nil
          expect(row[:DPMHIERARCHYREFERENCE]).to be_nil

        when 4
          expect(row[:CODE]).to eq('7')
          expect(row[:DPMMETRICDATATYPE]).to eq('Monetary')
          expect(row[:DPMFLOWTYPE]).to be_nil
          expect(row[:DPMBALANCETYPE]).to be_nil
          expect(row[:DPMDOMAINREFERENCE]).to be_nil
          expect(row[:DPMHIERARCHYREFERENCE]).to be_nil

        when 5
          expect(row[:CODE]).to eq('8')
          expect(row[:DPMMETRICDATATYPE]).to eq('Percentage')
          expect(row[:DPMFLOWTYPE]).to be_nil
          expect(row[:DPMBALANCETYPE]).to be_nil
          expect(row[:DPMDOMAINREFERENCE]).to be_nil
          expect(row[:DPMHIERARCHYREFERENCE]).to be_nil

        when 6
          expect(row[:CODE]).to eq('9')
          expect(row[:DPMMETRICDATATYPE]).to eq('String')
          expect(row[:DPMFLOWTYPE]).to be_nil
          expect(row[:DPMBALANCETYPE]).to be_nil
          expect(row[:DPMDOMAINREFERENCE]).to be_nil
          expect(row[:DPMHIERARCHYREFERENCE]).to be_nil

        when 7
          expect(row[:CODE]).to eq('10')
          expect(row[:DPMMETRICDATATYPE]).to eq('Decimal')
          expect(row[:DPMFLOWTYPE]).to be_nil
          expect(row[:DPMBALANCETYPE]).to be_nil
          expect(row[:DPMDOMAINREFERENCE]).to be_nil
          expect(row[:DPMHIERARCHYREFERENCE]).to be_nil

        when 8
          expect(row[:CODE]).to eq('11')
          expect(row[:DPMMETRICDATATYPE]).to eq('Lei')
          expect(row[:DPMFLOWTYPE]).to be_nil
          expect(row[:DPMBALANCETYPE]).to be_nil
          expect(row[:DPMDOMAINREFERENCE]).to be_nil
          expect(row[:DPMHIERARCHYREFERENCE]).to be_nil

        when 9
          expect(row[:CODE]).to eq('12')
          expect(row[:DPMMETRICDATATYPE]).to eq('Isin')
          expect(row[:DPMFLOWTYPE]).to be_nil
          expect(row[:DPMBALANCETYPE]).to be_nil
          expect(row[:DPMDOMAINREFERENCE]).to be_nil
          expect(row[:DPMHIERARCHYREFERENCE]).to be_nil

        when 10
          expect(row[:CODE]).to eq('13')
          expect(row[:DPMMETRICDATATYPE]).to eq('String')
          expect(row[:DPMFLOWTYPE]).to eq('Instant')
          expect(row[:DPMBALANCETYPE]).to eq('Credit')
          expect(row[:DPMDOMAINREFERENCE]).to be_nil
          expect(row[:DPMHIERARCHYREFERENCE]).to be_nil

        when 11
          expect(row[:CODE]).to eq('14')
          expect(row[:DPMMETRICDATATYPE]).to eq('String')
          expect(row[:DPMFLOWTYPE]).to eq('Duration')
          expect(row[:DPMBALANCETYPE]).to eq('Debit')
          expect(row[:DPMDOMAINREFERENCE]).to be_nil
          expect(row[:DPMHIERARCHYREFERENCE]).to be_nil

        when 12
          expect(row[:CODE]).to eq('16')
          expect(row[:DPMMETRICDATATYPE]).to eq('Date')
          expect(row[:DPMFLOWTYPE]).to be_nil
          expect(row[:DPMBALANCETYPE]).to be_nil
          expect(row[:DPMDOMAINREFERENCE]).to be_nil
          expect(row[:DPMHIERARCHYREFERENCE]).to be_nil
        end
      end
    end

    it 'Sheet 5/7: Members_MET1' do
      expect_each_row(workbooks, workbook_name, 'Members_MET1', 10) do |row, index|
        expect(row).to be_an_instance_of(Hash)

        case index
        when 0
          expect(row[:ID].length).to eq(36)
          expect(row[:CODE]).to eq('9')
          expect(row[:RELATION]).to be_nil
          expect(row[:PREFLABEL_FI]).to eq('MET hierarchy node (String)')
          expect(row[:PREFLABEL_EN]).to be_nil
          expect(row[:STARTDATE]).to be_nil
          expect(row[:ENDDATE]).to be_nil
          expect(row.length).to eq(7)

        when 1
          expect(row[:CODE]).to eq('10')
          expect(row[:RELATION]).to be_nil
          expect(row[:PREFLABEL_FI]).to eq('MET hierarchy node (Decimal)')

        when 2
          expect(row[:CODE]).to eq('11')
          expect(row[:RELATION]).to be_nil
          expect(row[:PREFLABEL_FI]).to eq('MET hierarchy node (Lei)')

        when 3
          expect(row[:CODE]).to eq('12')
          expect(row[:RELATION]).to be_nil
          expect(row[:PREFLABEL_FI]).to eq('MET hierarchy node (Isin)')

        when 4
          expect(row[:CODE]).to eq('3')
          expect(row[:RELATION]).to be_nil
          expect(row[:PREFLABEL_FI]).to eq('MET hierarchy node (Enumeration: EDA)')

        when 5
          expect(row[:CODE]).to eq('16')
          expect(row[:RELATION]).to be_nil
          expect(row[:PREFLABEL_FI]).to eq('MET hierarchy node (Date)')

        when 6
          expect(row[:CODE]).to eq('4')
          expect(row[:RELATION]).to be_nil
          expect(row[:PREFLABEL_FI]).to eq('MET hierarchy node (Boolean)')

        when 7
          expect(row[:CODE]).to eq('6')
          expect(row[:RELATION]).to be_nil
          expect(row[:PREFLABEL_FI]).to eq('MET hierarchy node (Integer)')

        when 8
          expect(row[:CODE]).to eq('7')
          expect(row[:RELATION]).to be_nil
          expect(row[:PREFLABEL_FI]).to eq('MET hierarchy node (Monetary)')

        when 9
          expect(row[:CODE]).to eq('8')
          expect(row[:RELATION]).to be_nil
          expect(row[:PREFLABEL_FI]).to eq('MET hierarchy node (Percentage)')
        end
      end
    end

    it 'Sheet 6/7: Members_MET10' do
      expect_each_row(workbooks, workbook_name, 'Members_MET10', 12) do |row, index|
        expect(row).to be_an_instance_of(Hash)

        case index
        when 0
          expect(row[:ID].length).to eq(36)
          expect(row[:CODE]).to eq('4')
          expect(row[:PREFLABEL_FI]).to eq('MET hierarchy node (Boolean)')
          expect(row[:PREFLABEL_EN]).to be_nil
          expect(row[:STARTDATE]).to be_nil
          expect(row[:ENDDATE]).to be_nil
          expect(row[:RELATION]).to be_nil
          expect(row.length).to eq(7)

        when 1
          expect(row[:CODE]).to eq('3')
          expect(row[:PREFLABEL_FI]).to eq('MET hierarchy node (Enumeration: EDA)')
          expect(row[:RELATION]).to be_nil

        when 2
          expect(row[:CODE]).to eq('16')
          expect(row[:PREFLABEL_FI]).to eq('MET hierarchy node (Date)')
          expect(row[:RELATION]).to be_nil

        when 3
          expect(row[:CODE]).to eq('9')
          expect(row[:PREFLABEL_FI]).to eq('MET hierarchy node (String)')
          expect(row[:RELATION]).to eq('code:16')

        when 4
          expect(row[:CODE]).to eq('13')
          expect(row[:PREFLABEL_FI]).to eq('MET hierarchy node (String, Instant, Credit)')
          expect(row[:RELATION]).to eq('code:16')

        when 5
          expect(row[:CODE]).to eq('14')
          expect(row[:PREFLABEL_FI]).to eq('MET hierarchy node (String, Duration, Debit)')
          expect(row[:RELATION]).to eq('code:13')

        when 6
          expect(row[:CODE]).to eq('7')
          expect(row[:PREFLABEL_FI]).to eq('MET hierarchy node (Monetary)')
          expect(row[:RELATION]).to eq('code:16')

        when 7
          expect(row[:CODE]).to eq('11')
          expect(row[:PREFLABEL_FI]).to eq('MET hierarchy node (Lei)')
          expect(row[:RELATION]).to eq('code:7')

        when 8
          expect(row[:CODE]).to eq('8')
          expect(row[:PREFLABEL_FI]).to eq('MET hierarchy node (Percentage)')
          expect(row[:RELATION]).to eq('code:7')

        when 9
          expect(row[:CODE]).to eq('12')
          expect(row[:PREFLABEL_FI]).to eq('MET hierarchy node (Isin)')
          expect(row[:RELATION]).to eq('code:7')

        when 10
          expect(row[:CODE]).to eq('10')
          expect(row[:PREFLABEL_FI]).to eq('MET hierarchy node (Decimal)')
          expect(row[:RELATION]).to eq('code:7')

        when 11
          expect(row[:CODE]).to eq('6')
          expect(row[:PREFLABEL_FI]).to eq('MET hierarchy node (Integer)')
          expect(row[:RELATION]).to be_nil

        end
      end
    end

    it 'Sheet 7/7: Members_METHIER' do
      expect_each_row(workbooks, workbook_name, 'Members_METHIER', 1) do |row, index|
        expect(row).to be_an_instance_of(Hash)

        case index
        when 0
          expect(row[:ID].length).to eq(36)
          expect(row[:CODE]).to eq('1')
          expect(row[:RELATION]).to be_nil
          expect(row[:PREFLABEL_FI]).to eq('Metric hierarchy node (fi, label)')
          expect(row[:PREFLABEL_EN]).to be_nil
          expect(row[:STARTDATE]).to be_nil
          expect(row[:ENDDATE]).to be_nil
          expect(row.length).to eq(7)

        end
      end
    end
  end
end
