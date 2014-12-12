module Pagination
  extend ActiveSupport::Concern

  def current_page
    (params['page'] || 1).to_i
  end

  def per_page
    (params['per'] || 10).to_i
  end

  def pagination_headers(total_pages)
    response.headers['TOTAL-PAGES'] =  total_pages
    response.headers['CURRENT-PAGE'] = current_page
  end
end
