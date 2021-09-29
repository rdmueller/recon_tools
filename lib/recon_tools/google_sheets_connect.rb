# FileImporter
require "json"

# Googlesheets
require "google_drive"
require "google/apis/sheets_v4"
require "google_docs"

class GoogleSheetsConnect
  @session
  def initialize(json_crednetials = "../config/credentials.json")
    #credentials = File.read("../config/credentials.json")
    #puts credentials
    @session = GoogleDrive::Session.from_service_account_key(json_crednetials)
  end

  def insert_data(dataToInsert, sheetName)
    spreadsheet = @session.spreadsheet_by_title(sheetName)
    worksheet = spreadsheet.worksheets.first
#    worksheet.rows.each { |row| puts row.first(6).join(" | ") }

    worksheet.insert_rows(1 , dataToInsert)
    worksheet.save
  end

  def update_data(data_to_insert, sheet_name)
    spreadsheet = @session.spreadsheet_by_title(sheet_name)
    worksheet = spreadsheet.worksheets.first

    data_to_insert.each_with_index do |row, rowIndex|
      row.each_with_index do |value, colIndex|
        worksheet[rowIndex+1, colIndex+1]= value
        puts "#{rowIndex}, #{colIndex} = #{value}"
      end
    end
    worksheet.save
  end

  def read_sheet_data(sheetName, skip_rows=0)
    spreadsheet = @session.spreadsheet_by_title(sheetName)
    worksheet = spreadsheet.worksheets.first
    worksheet.rows skip_rows
  end

  def update_test_sheet(sheetName)
    #BEST Example: https://www.youtube.com/watch?v=VqoSUSy011I
    #https://www.twilio.com/blog/2017/03/google-spreadsheets-ruby.html

    # Authenticate a session with your Service Account
    #session = GoogleDrive::Session.from_service_account_key("../../config/credentials.json")
    #https://docs.google.com/spreadsheets/d/1_<ID>/edit#gid=152787366

    # Get the spreadsheet by its title
    spreadsheet = session.spreadsheet_by_title(sheetName)
    # Get the first worksheet
    worksheet = spreadsheet.worksheets.first
    # Print out the first 6 columns of each row
    worksheet.rows.each { |row| puts row.first(6).join(" | ") }

    worksheet.insert_rows(worksheet.num_rows + 1 ,
    [
      ["col1", "col2"],
      ["col2", "col3"]
    ]
    )

    worksheet.save
    worksheet["C5"] = "updated"

    worksheet.save
  end
end
