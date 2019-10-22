module PageTitleHelper
  def page_title(title = '')
    if title.present?
      title + " - #{I18n.t('page_title_suffix')}"
    else
      I18n.t('page_title_suffix')
    end
  end
end
