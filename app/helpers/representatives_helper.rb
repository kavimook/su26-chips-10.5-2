# frozen_string_literal: true

module RepresentativesHelper
  def social_links(representative)
    links = []
    if representative.twitter.present?
      links << link_to('Twitter', "https://twitter.com/#{representative.twitter}",
                       target: '_blank', rel: 'noopener', class: 'me-2')
    end
    if representative.facebook.present?
      links << link_to('Facebook', "https://facebook.com/#{representative.facebook}",
                       target: '_blank', rel: 'noopener')
    end
    safe_join(links)
  end
end
