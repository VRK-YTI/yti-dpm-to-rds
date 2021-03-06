require 'rspec'

RSpec.describe DpmYtiMapping::ExplicitDomainsAndHierarchies do

  let(:owner) { DpmDbModel::Owner.by_name('Suomi SBR') }
  let(:workbooks) { DpmYtiMapping::ExplicitDomainsAndHierarchies.generate_workbooks(owner) }

  it 'should produce total 1 + 7 workbooks' do
    expect(workbooks.length).to eq(1 + 7)
  end

  context 'Workbook: explicit-domains' do
    let(:workbook_name) { 'explicit-domains-2018-1' }

    it 'should have 3 sheets' do
      expect_each_sheet(workbooks, workbook_name, 3) do |sheet, index|
        expect(sheet).to be_an_instance_of(WorkbookModel::SheetData)

        case index
        when 0
          expect(sheet.sheet_name).to eq('CodeSchemes')
        when 1
          expect(sheet.sheet_name).to eq('Codes')
        when 2
          expect(sheet.sheet_name).to eq('Extensions')
        end
      end
    end

    it 'Sheet 1/3: CodeSchemes' do
      expect_each_row(workbooks, workbook_name, 'CodeSchemes', 1) do |row, index|
        expect(row).to be_an_instance_of(Hash)

        case index
        when 0
          expect(row[:ID].length).to eq(36)
          expect(row[:INFORMATIONDOMAIN]).to eq('P14')
          expect(row[:LANGUAGECODE]).to eq('fi;sv;en')
          expect(row[:STATUS]).to eq('DRAFT')
          expect(row[:CODEVALUE]).to eq('exp-doms-2018-1')
          expect(row[:DEFAULTCODE]).to be_nil
          expect(row[:PREFLABEL_FI]).to start_with('Explicit Domains 2018-1')
          expect(row[:PREFLABEL_EN]).to be_nil
          expect(row[:DESCRIPTION_FI]).to start_with('Lista Explicit Domaineista')
          expect(row[:DESCRIPTION_EN]).to be_nil
          expect(row[:STARTDATE]).to be_nil
          expect(row[:ENDDATE]).to be_nil
          expect(row[:CODESSHEET]).to eq('Codes')
          expect(row[:EXTENSIONSSHEET]).to eq('Extensions')
          expect(row.length).to eq(14)
        end
      end
    end

    it 'Sheet 2/3: Codes' do
      expect_each_row(workbooks, workbook_name, 'Codes', 1 + 6) do |row, index|
        expect(row).to be_an_instance_of(Hash)

        case index
        when 0
          expect(row[:ID].length).to eq(36)
          expect(row[:STATUS]).to eq('DRAFT')
          expect(row[:CODEVALUE]).to eq('DOME')
          expect(row[:BROADER]).to be_nil
          expect(row[:PREFLABEL_FI]).to eq('Explicit domain (fi, label)')
          expect(row[:PREFLABEL_EN]).to be_nil
          expect(row[:DESCRIPTION_FI]).to eq('Explicit domain (fi, description)')
          expect(row[:DESCRIPTION_EN]).to be_nil
          expect(row[:STARTDATE]).to eq('2018-12-31') # DM issue: date is written wrongly to DB
          expect(row[:ENDDATE]).to eq('2019-05-30')
          expect(row[:SUBCODESCHEME]).to eq(codescheme_id_from(workbooks, 'DOME-2018-1'))
          expect(row.length).to eq(11)

        when 1
          expect(row[:ID].length).to eq(36)
          expect(row[:STATUS]).to eq('DRAFT')
          expect(row[:CODEVALUE]).to eq('EDA')
          expect(row[:BROADER]).to be_nil
          expect(row[:PREFLABEL_FI]).to eq('Explicit domain A')
          expect(row[:PREFLABEL_EN]).to be_nil
          expect(row[:DESCRIPTION_FI]).to eq('')
          expect(row[:DESCRIPTION_EN]).to be_nil
          expect(row[:STARTDATE]).to eq('2018-10-31') # DM issue: date is written wrongly to DB
          expect(row[:ENDDATE]).to be_nil
          expect(row[:SUBCODESCHEME]).to eq(codescheme_id_from(workbooks, 'EDA-2018-1'))
          expect(row.length).to eq(11)

        when 2
          expect(row[:CODEVALUE]).to eq('EDA1')
          expect(row[:PREFLABEL_FI]).to eq('Explicit domain A1')

        when 3
          expect(row[:CODEVALUE]).to eq('EDA9')
          expect(row[:PREFLABEL_FI]).to eq('Explicit domain A9')

        when 4
          expect(row[:CODEVALUE]).to eq('EDA10')
          expect(row[:PREFLABEL_FI]).to eq('Explicit domain A10')

        when 5
          expect(row[:CODEVALUE]).to eq('EDA11')
          expect(row[:PREFLABEL_FI]).to eq('Explicit domain A11')

        when 6
          expect(row[:CODEVALUE]).to eq('EDA20')
          expect(row[:PREFLABEL_FI]).to eq('Explicit domain A20')

        end
      end
    end

    it 'Sheet 3/3: Extensions' do
      expect_each_row(workbooks, workbook_name, 'Extensions', 1) do |row, index|
        expect(row).to be_an_instance_of(Hash)

        case index
        when 0
          expect(row[:ID].length).to eq(36)
          expect(row[:CODEVALUE]).to eq('dpmExplicitDomain')
          expect(row[:STATUS]).to eq('DRAFT')
          expect(row[:PROPERTYTYPE]).to eq('dpmExplicitDomain')
          expect(row[:PREFLABEL_FI]).to be_nil
          expect(row[:PREFLABEL_EN]).to be_nil
          expect(row[:STARTDATE]).to be_nil
          expect(row[:ENDDATE]).to be_nil
          expect(row[:MEMBERSSHEET]).to be_nil
          expect(row.length).to eq(9)
        end
      end
    end
  end

  context 'Workbook: domain-members-and-hierarchies EDA' do
    let(:workbook_name) { 'ed-EDA-2018-1-members-and-hierarchies' }

    it 'should have 3+3 sheets' do
      expect_each_sheet(workbooks, workbook_name, 3 + 3) do |sheet, index|
        expect(sheet).to be_an_instance_of(WorkbookModel::SheetData)

        case index
        when 0
          expect(sheet.sheet_name).to eq('CodeSchemes')
        when 1
          expect(sheet.sheet_name).to eq('Codes')
        when 2
          expect(sheet.sheet_name).to eq('Extensions')
        when 3
          expect(sheet.sheet_name).to eq('Members_EDA-H1')
        when 4
          expect(sheet.sheet_name).to eq('Members_EDA-H2')
        when 5
          expect(sheet.sheet_name).to eq('Members_EDA-H10')
        end
      end
    end

    it 'Sheet 1/6: CodeSchemes' do
      expect_each_row(workbooks, workbook_name, 'CodeSchemes', 1) do |row, index|
        expect(row).to be_an_instance_of(Hash)

        case index
        when 0
          expect(row[:ID].length).to eq(36)
          expect(row[:INFORMATIONDOMAIN]).to eq('P14')
          expect(row[:LANGUAGECODE]).to eq('fi;sv;en')
          expect(row[:STATUS]).to eq('DRAFT')
          expect(row[:CODEVALUE]).to eq('EDA-2018-1')
          expect(row[:DEFAULTCODE]).to eq('EDA-x3')
          expect(row[:PREFLABEL_FI]).to eq('Explicit domain A 2018-1')
          expect(row[:PREFLABEL_EN]).to be_nil
          expect(row[:DESCRIPTION_FI]).to be_nil
          expect(row[:DESCRIPTION_EN]).to be_nil
          expect(row[:STARTDATE]).to be_nil
          expect(row[:ENDDATE]).to be_nil
          expect(row[:CODESSHEET]).to eq('Codes')
          expect(row[:EXTENSIONSSHEET]).to eq('Extensions')

          expect(row.length).to eq(14)
        end
      end
    end

    it 'Sheet 2/6: Codes' do
      expect_each_row(workbooks, workbook_name, 'Codes', 13) do |row, index|
        expect(row).to be_an_instance_of(Hash)

        case index
        when 0
          expect(row[:ID].length).to eq(36)
          expect(row[:STATUS]).to eq('DRAFT')
          expect(row[:CODEVALUE]).to eq('EDA-x1')
          expect(row[:BROADER]).to be_nil
          expect(row[:PREFLABEL_FI]).to eq('EDA member 1')
          expect(row[:PREFLABEL_EN]).to be_nil
          expect(row[:DESCRIPTION_FI]).to eq('')
          expect(row[:DESCRIPTION_EN]).to be_nil
          expect(row[:STARTDATE]).to eq('2018-10-31') # DM issue: date is written wrongly to DB
          expect(row[:ENDDATE]).to be_nil
          expect(row.length).to eq(10)

        when 1
          expect(row[:CODEVALUE]).to eq('EDA-x2')

        when 2
          expect(row[:CODEVALUE]).to eq('EDA-x3')

        when 3
          expect(row[:ID].length).to eq(36)
          expect(row[:STATUS]).to eq('DRAFT')
          expect(row[:CODEVALUE]).to eq('EDA-x4')
          expect(row[:BROADER]).to be_nil
          expect(row[:PREFLABEL_FI]).to eq('EDA member (=, 1)')
          expect(row[:PREFLABEL_EN]).to be_nil
          expect(row[:DESCRIPTION_FI]).to eq('')
          expect(row[:DESCRIPTION_EN]).to be_nil
          expect(row[:STARTDATE]).to eq('2018-10-31') # DM issue: date is written wrongly to DB
          expect(row[:ENDDATE]).to be_nil
          expect(row.length).to eq(10)

        when 4
          expect(row[:CODEVALUE]).to eq('EDA-x5')

        when 5
          expect(row[:CODEVALUE]).to eq('EDA-x6')

        when 6
          expect(row[:CODEVALUE]).to eq('EDA-x7')

        when 7
          expect(row[:CODEVALUE]).to eq('EDA-x8')

        when 8
          expect(row[:CODEVALUE]).to eq('EDA-x9')

        when 9
          expect(row[:CODEVALUE]).to eq('EDA-x10')

        when 10
          expect(row[:CODEVALUE]).to eq('EDA-x19')

        when 11
          expect(row[:CODEVALUE]).to eq('EDA-x20')

        when 12
          expect(row[:CODEVALUE]).to eq('EDA-x21')

        end
      end
    end

    it 'Sheet 3/6: Extensions' do
      expect_each_row(workbooks, workbook_name, 'Extensions', 3) do |row, index|
        expect(row).to be_an_instance_of(Hash)

        case index
        when 0
          expect(row[:ID].length).to eq(36)
          expect(row[:CODEVALUE]).to eq('EDA-H1')
          expect(row[:STATUS]).to eq('DRAFT')
          expect(row[:PROPERTYTYPE]).to eq('definitionHierarchy')
          expect(row[:PREFLABEL_FI]).to eq('EDA hierarchy 1')
          expect(row[:PREFLABEL_EN]).to be_nil
          expect(row[:STARTDATE]).to eq('2018-10-31') # DM issue: date is written wrongly to DB
          expect(row[:ENDDATE]).to be_nil
          expect(row[:MEMBERSSHEET]).to eq('Members_EDA-H1')
          expect(row.length).to eq(9)

        when 1
          expect(row[:CODEVALUE]).to eq('EDA-H2')
          expect(row[:PROPERTYTYPE]).to eq('calculationHierarchy')
          expect(row[:PREFLABEL_FI]).to eq('EDA hierarchy 2')

        when 2
          expect(row[:CODEVALUE]).to eq('EDA-H10')
          expect(row[:PROPERTYTYPE]).to eq('definitionHierarchy')
          expect(row[:PREFLABEL_FI]).to eq('EDA hierarchy 10')
        end
      end
    end

    it 'Sheet 4/6: Members_EDA-H1' do
      expect_each_row(workbooks, workbook_name, 'Members_EDA-H1', 8) do |row, index|
        expect(row).to be_an_instance_of(Hash)

        case index
        when 0
          expect(row[:ID].length).to eq(36)
          expect(row[:CODE]).to eq('EDA-x20')
          expect(row[:PREFLABEL_FI]).to eq('EDA hierarchy node 7')
          expect(row[:PREFLABEL_EN]).to be_nil
          expect(row[:STARTDATE]).to be_nil
          expect(row[:ENDDATE]).to be_nil
          expect(row[:RELATION]).to be_nil
          expect(row.length).to eq(7)

        when 1
          expect(row[:CODE]).to eq('EDA-x9')
          expect(row[:PREFLABEL_FI]).to eq('EDA hierarchy node 4')
          expect(row[:RELATION]).to be_nil

        when 2
          expect(row[:CODE]).to eq('EDA-x10')
          expect(row[:PREFLABEL_FI]).to eq('EDA hierarchy node 5')
          expect(row[:RELATION]).to eq('code:EDA-x9')

        when 3
          expect(row[:CODE]).to eq('EDA-x19')
          expect(row[:PREFLABEL_FI]).to eq('EDA hierarchy node 6')
          expect(row[:RELATION]).to be_nil

        when 4
          expect(row[:CODE]).to eq('EDA-x2')
          expect(row[:PREFLABEL_FI]).to eq('EDA hierarchy node 2')
          expect(row[:RELATION]).to be_nil

        when 5
          expect(row[:CODE]).to eq('EDA-x1')
          expect(row[:PREFLABEL_FI]).to eq('EDA hierarchy node 1')
          expect(row[:RELATION]).to eq('code:EDA-x2')

        when 6
          expect(row[:CODE]).to eq('EDA-x3')
          expect(row[:PREFLABEL_FI]).to eq('EDA hierarchy node 3')
          expect(row[:RELATION]).to eq('code:EDA-x2')

        when 7
          expect(row[:CODE]).to eq('EDA-x21')
          expect(row[:PREFLABEL_FI]).to eq('EDA hierarchy node 8')
          expect(row[:RELATION]).to be_nil

        end
      end
    end

    it 'Sheet 5/6: Members_EDA-H2' do
      expect_each_row(workbooks, workbook_name, 'Members_EDA-H2', 5) do |row, index|
        expect(row).to be_an_instance_of(Hash)

        case index
        when 0
          expect(row[:ID].length).to eq(36)
          expect(row[:CODE]).to eq('EDA-x4')
          expect(row[:RELATION]).to be_nil
          expect(row[:UNARYOPERATOR]).to eq('+')
          expect(row[:COMPARISONOPERATOR]).to eq('=')
          expect(row[:PREFLABEL_FI]).to eq('EDA hierarchy node (=, 1)')
          expect(row[:PREFLABEL_EN]).to be_nil
          expect(row[:STARTDATE]).to be_nil
          expect(row[:ENDDATE]).to be_nil
          expect(row.length).to eq(9)

        when 1
          expect(row[:CODE]).to eq('EDA-x5')
          expect(row[:RELATION]).to be_nil
          expect(row[:UNARYOPERATOR]).to be_nil
          expect(row[:COMPARISONOPERATOR]).to eq('>')
          expect(row[:PREFLABEL_FI]).to eq('EDA hierarchy node (>, 2)')

        when 2
          expect(row[:CODE]).to eq('EDA-x6')
          expect(row[:RELATION]).to be_nil
          expect(row[:UNARYOPERATOR]).to be_nil
          expect(row[:COMPARISONOPERATOR]).to eq('<')
          expect(row[:PREFLABEL_FI]).to eq('EDA hierarchy node (<, 0)')

        when 3
          expect(row[:CODE]).to eq('EDA-x7')
          expect(row[:RELATION]).to be_nil
          expect(row[:UNARYOPERATOR]).to eq('-')
          expect(row[:COMPARISONOPERATOR]).to eq('>=')
          expect(row[:PREFLABEL_FI]).to eq('EDA hierarchy node (>=, -1)')

        when 4
          expect(row[:CODE]).to eq('EDA-x8')
          expect(row[:RELATION]).to be_nil
          expect(row[:UNARYOPERATOR]).to be_nil
          expect(row[:COMPARISONOPERATOR]).to eq('<=')
          expect(row[:PREFLABEL_FI]).to eq('EDA hierarchy node (<=, -2)')
        end
      end
    end

    it 'Sheet 5/6: Members_EDA-H10' do
      expect_each_row(workbooks, workbook_name, 'Members_EDA-H10', 0) do |row, index|
      end
    end
  end

  context 'Workbook: domain-members-and-hierarchies DOME' do
    let(:workbook_name) { 'ed-DOME-2018-1-members-and-hierarchies' }

    it 'should have 5 sheets' do
      expect_each_sheet(workbooks, workbook_name, 5) do |sheet, index|
        expect(sheet).to be_an_instance_of(WorkbookModel::SheetData)

        case index
        when 0
          expect(sheet.sheet_name).to eq('CodeSchemes')
        when 1
          expect(sheet.sheet_name).to eq('Codes')
        when 2
          expect(sheet.sheet_name).to eq('Extensions')
        when 3
          expect(sheet.sheet_name).to eq('Members_EDA-H1')
        when 4
          expect(sheet.sheet_name).to eq('Members_HIER')
        end
      end
    end

    it 'Sheet 1/5: CodeSchemes' do
      expect_each_row(workbooks, workbook_name, 'CodeSchemes', 1) do |row, index|
        expect(row).to be_an_instance_of(Hash)

        case index
        when 0
          expect(row[:ID].length).to eq(36)
          expect(row[:INFORMATIONDOMAIN]).to eq('P14')
          expect(row[:LANGUAGECODE]).to eq('fi;sv;en')
          expect(row[:STATUS]).to eq('DRAFT')
          expect(row[:CODEVALUE]).to eq('DOME-2018-1')
          expect(row[:DEFAULTCODE]).to be_nil
          expect(row[:PREFLABEL_FI]).to eq('Explicit domain (fi, label) 2018-1')
          expect(row[:PREFLABEL_EN]).to be_nil
          expect(row[:DESCRIPTION_FI]).to be_nil
          expect(row[:DESCRIPTION_EN]).to be_nil
          expect(row[:STARTDATE]).to be_nil
          expect(row[:ENDDATE]).to be_nil
          expect(row[:CODESSHEET]).to eq('Codes')
          expect(row[:EXTENSIONSSHEET]).to eq('Extensions')

          expect(row.length).to eq(14)
        end
      end
    end

    it 'Sheet 2/5: Codes' do
      expect_each_row(workbooks, workbook_name, 'Codes', 2) do |row, index|
        expect(row).to be_an_instance_of(Hash)

        case index
        when 0
          expect(row[:ID].length).to eq(36)
          expect(row[:STATUS]).to eq('DRAFT')
          expect(row[:CODEVALUE]).to eq('EDA-x1')
          expect(row[:BROADER]).to be_nil
          expect(row[:PREFLABEL_FI]).to eq('DOME member duplicating EDA code')
          expect(row[:PREFLABEL_EN]).to be_nil
          expect(row[:DESCRIPTION_FI]).to eq('')
          expect(row[:DESCRIPTION_EN]).to be_nil
          expect(row[:STARTDATE]).to eq('2018-12-31') # DM issue: date is written wrongly to DB
          expect(row[:ENDDATE]).to be_nil
          expect(row.length).to eq(10)

        when 1
          expect(row[:ID].length).to eq(36)
          expect(row[:STATUS]).to eq('DRAFT')
          expect(row[:CODEVALUE]).to eq('MEM')
          expect(row[:BROADER]).to be_nil
          expect(row[:PREFLABEL_FI]).to eq('Member (fi, label)')
          expect(row[:PREFLABEL_EN]).to be_nil
          expect(row[:DESCRIPTION_FI]).to eq('Member (fi, description)')
          expect(row[:DESCRIPTION_EN]).to be_nil
          expect(row[:STARTDATE]).to eq('2018-10-31') # DM issue: date is written wrongly to DB
          expect(row[:ENDDATE]).to be_nil
          expect(row.length).to eq(10)
        end


      end
    end

    it 'Sheet 3/5: Extensions' do
      expect_each_row(workbooks, workbook_name, 'Extensions', 2) do |row, index|
        expect(row).to be_an_instance_of(Hash)

        case index
        when 0
          expect(row[:ID].length).to eq(36)
          expect(row[:CODEVALUE]).to eq('EDA-H1')
          expect(row[:STATUS]).to eq('DRAFT')
          expect(row[:PROPERTYTYPE]).to eq('definitionHierarchy')
          expect(row[:PREFLABEL_FI]).to eq('DOME hierarchy duplicating EDA code')
          expect(row[:PREFLABEL_EN]).to be_nil
          expect(row[:STARTDATE]).to eq('2018-12-31') # DM issue: date is written wrongly to DB
          expect(row[:ENDDATE]).to be_nil
          expect(row[:MEMBERSSHEET]).to eq('Members_EDA-H1')
          expect(row.length).to eq(9)

        when 1
          expect(row[:ID].length).to eq(36)
          expect(row[:CODEVALUE]).to eq('HIER')
          expect(row[:STATUS]).to eq('DRAFT')
          expect(row[:PROPERTYTYPE]).to eq('definitionHierarchy')
          expect(row[:PREFLABEL_FI]).to eq('Hierarchy (fi, label)')
          expect(row[:PREFLABEL_EN]).to be_nil
          expect(row[:STARTDATE]).to eq('2018-10-31') # DM issue: date is written wrongly to DB
          expect(row[:ENDDATE]).to be_nil
          expect(row[:MEMBERSSHEET]).to eq('Members_HIER')
          expect(row.length).to eq(9)
        end
      end
    end

    it 'Sheet 4/5: Members_EDA-H1' do
      expect_each_row(workbooks, workbook_name, 'Members_EDA-H1', 0) do |row, index|
        expect(row).to be_an_instance_of(Hash)

      end
    end

    it 'Sheet 5/5: Members_HIER' do
      expect_each_row(workbooks, workbook_name, 'Members_HIER', 1) do |row, index|
        expect(row).to be_an_instance_of(Hash)

        case index
        when 0
          expect(row[:ID].length).to eq(36)
          expect(row[:CODE]).to eq('MEM')
          expect(row[:RELATION]).to be_nil
          expect(row[:PREFLABEL_FI]).to eq('Hierarchy node (fi, label)')
          expect(row[:PREFLABEL_EN]).to be_nil
          expect(row[:STARTDATE]).to be_nil
          expect(row[:ENDDATE]).to be_nil
          expect(row.length).to eq(7)
        end
      end
    end
  end
end