class TestSets::DownloadsController < ApplicationController
  allow_unauthenticated_access only: [ :show ]

  def show
    @test_set = TestSet.find(params[:test_set_id])

    send_file @test_set.all_inputs_zip_path,
      type: "application/zip", filename: "#{@test_set.name}.zip"
  end
end
