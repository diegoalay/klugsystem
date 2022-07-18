class BooksController < ApplicationSystemController
  def purchases
    respond_to do |format|
      format.html {}
      format.json do
        respond_with_successful()
      end
    end
  end

  def sales
    respond_to do |format|
      format.html {}
      format.json do
        respond_with_successful()
      end
    end
  end
end
