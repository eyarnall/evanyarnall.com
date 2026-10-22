# Structured data for search engines and AI tools, built from the files the site already uses:
# _data/cv.yml, _data/socials.yml, _data/schema.yml (the lab and Dr. Ferre) and _bibliography/papers.bib.
#
#   site.data["papers"]  the entries of papers.bib, for plain-text pages such as /llms.txt
#   {% schema_graph %}   the page's schema.org JSON-LD (used in _includes/metadata.liquid)
require "bibtex"
require "date"
require "json"
require "time"

module StructuredData
  MONTHS = %w[jan feb mar apr may jun jul aug sep oct nov dec].freeze

  SOCIAL_URLS = {
    "orcid_id" => "https://orcid.org/%s",
    "linkedin_username" => "https://www.linkedin.com/in/%s",
    "github_username" => "https://github.com/%s",
    "scholar_userid" => "https://scholar.google.com/citations?user=%s",
    "researchgate_profile" => "https://www.researchgate.net/profile/%s",
  }.freeze

  module_function

  # --- papers.bib -------------------------------------------------------------------------------

  def papers(site)
    path = File.join(site.source, "_bibliography", "papers.bib")
    BibTeX.open(path, filter: :latex).data.grep(BibTeX::Entry).map do |entry|
      paper = { "key" => entry.key.to_s, "type" => entry.type.to_s }
      entry.fields.each { |name, value| paper[name.to_s] = value.to_s.strip unless name == :author }
      paper["authors"] = entry.author.to_a.map { |n| { "first" => n.first.to_s, "last" => n.last.to_s } }
      paper["author_list"] = paper["authors"].map { |a| "#{a['first']} #{a['last']}" }.join(", ")
      paper["date"] = date(paper)
      paper["month_name"] = month_name(paper)
      paper
    end
  end

  # "2026" + "Sep" -> "2026-09". Manuscripts in preparation have no date.
  def date(paper)
    year = paper["year"].to_s
    return nil unless year.match?(/\A\d{4}\z/)

    month = MONTHS.index(paper["month"].to_s[0, 3].downcase)
    month ? format("%s-%02d", year, month + 1) : year
  end

  # "sep" -> "September" (the BibTeX parser lowercases months).
  def month_name(paper)
    month = MONTHS.index(paper["month"].to_s[0, 3].downcase)
    month && Date::MONTHNAMES[month + 1]
  end

  # --- The graph --------------------------------------------------------------------------------

  def ids(site)
    base = site.config["url"].to_s.chomp("/")
    {
      base: base,
      website: "#{base}/#website",
      person: "#{base}/#person",
      lab: "#{base}/#demr-lab",
      ferre: "#{base}/#claudio-ferre",
      sargent: "#{base}/#bu-sargent",
      neurophotonics: "#{base}/#bu-neurophotonics",
      bu: "#{base}/#boston-university",
    }
  end

  def full_name(site)
    [site.config["first_name"], site.config["last_name"]].compact.join(" ")
  end

  def graph(site, page)
    id = ids(site)
    facts = site.data["schema"] || {}
    [
      website(site, id),
      person(site, facts, id),
      ferre(facts, id),
      lab(facts, id),
      org("CollegeOrUniversity", facts["sargent"], id[:sargent], "parentOrganization" => { "@id" => id[:bu] }),
      org("ResearchOrganization", facts["neurophotonics"], id[:neurophotonics],
          "parentOrganization" => { "@id" => id[:bu] }),
      org("CollegeOrUniversity", facts["bu"], id[:bu]),
      page_node(site, page, id),
    ]
  end

  def website(site, id)
    {
      "@type" => "WebSite",
      "@id" => id[:website],
      "url" => "#{id[:base]}/",
      "name" => full_name(site),
      "description" => site.config["description"],
      "inLanguage" => "en-US",
      "publisher" => { "@id" => id[:person] },
      "about" => { "@id" => id[:person] },
    }
  end

  def person(site, facts, id)
    cv = site.data.dig("cv", "cv") || {}
    alumni = (cv["education"] || []).reject { |e| e["expected"] }.map do |e|
      { "@type" => "CollegeOrUniversity", "name" => e["institution"].to_s.split(",").first.strip }
    end
    awards = (cv["awards"] || []).map { |a| "#{a['title']}, #{a['awarder']} (#{a['date']})" }
    # Training programs he belongs to (cv.yml "training"). These pages list whole cohorts, so they are
    # program memberships rather than "sameAs" profile links.
    programs = (cv["training"] || []).map do |t|
      {
        "@type" => "ProgramMembership",
        "programName" => t["program_name"] || t["program"],
        "hostingOrganization" => { "@type" => "Organization", "name" => t["organization"] },
        "url" => t["url"],
      }.compact
    end
    same_as = (site.data["socials"] || {}).filter_map do |key, value|
      format(SOCIAL_URLS[key], value) if SOCIAL_URLS[key] && value
    end
    {
      "@type" => "Person",
      "@id" => id[:person],
      "name" => cv["name"] || full_name(site),
      "givenName" => site.config["first_name"],
      "familyName" => site.config["last_name"],
      "url" => "#{id[:base]}/",
      "image" => {
        "@type" => "ImageObject",
        "url" => "#{id[:base]}/assets/img/prof_pic.jpg",
        "caption" => cv["name"] || full_name(site),
      },
      "jobTitle" => cv["label"],
      "description" => site.config["description"],
      "affiliation" => { "@id" => id[:lab] },
      "memberOf" => [{ "@id" => id[:lab] }] + programs,
      "colleague" => { "@id" => id[:ferre] },
      "alumniOf" => alumni,
      "knowsAbout" => facts["knows_about"],
      "award" => awards,
      "hasOccupation" => occupation(cv),
      "hasCredential" => credentials(cv),
      "sameAs" => same_as,
    }.reject { |_, v| v.nil? || v == [] }
  end

  def ferre(facts, id)
    { "@type" => "Person", "@id" => id[:ferre] }.merge(facts["ferre"] || {}).merge(
      "worksFor" => { "@id" => id[:bu] },
      "affiliation" => [{ "@id" => id[:sargent] }, { "@id" => id[:neurophotonics] }],
      "memberOf" => { "@id" => id[:lab] }
    )
  end

  def lab(facts, id)
    lab = (facts["lab"] || {}).dup
    lab["address"] = { "@type" => "PostalAddress" }.merge(lab["address"]) if lab["address"]
    { "@type" => "ResearchOrganization", "@id" => id[:lab] }.merge(lab).merge(
      "parentOrganization" => { "@id" => id[:sargent] },
      "member" => [{ "@id" => id[:ferre] }, { "@id" => id[:person] }]
    )
  end

  def org(type, facts, node_id, extra = {})
    { "@type" => type, "@id" => node_id }.merge(facts || {}).merge(extra)
  end

  # Current role, from the first position in cv.yml ("Graduate Researcher, DEMR Lab" -> "Graduate Researcher").
  def occupation(cv)
    title = (cv["experience"] || []).first&.dig("position").to_s.split(",").first.to_s.strip
    title.empty? ? nil : { "@type" => "Occupation", "name" => title }
  end

  # Completed degrees and certificates from cv.yml.
  def credentials(cv)
    degrees = (cv["education"] || []).reject { |e| e["expected"] }.map do |e|
      {
        "@type" => "EducationalOccupationalCredential",
        "credentialCategory" => "degree",
        "name" => e["degree"],
        "recognizedBy" => { "@type" => "CollegeOrUniversity", "name" => e["institution"].to_s.split(",").first.strip },
      }
    end
    certificates = (cv["certificates"] || []).map do |c|
      {
        "@type" => "EducationalOccupationalCredential",
        "credentialCategory" => "certificate",
        "name" => c["name"],
        "recognizedBy" => { "@type" => "Organization", "name" => c["issuer"] },
        "dateCreated" => c["date"].to_s,
      }
    end
    degrees + certificates
  end

  # Home > page, or Home > Research > project for project pages.
  def breadcrumb(site, page, id)
    trail = [["Home", "#{id[:base]}/"]]
    trail << ["Research", "#{id[:base]}/research/"] if page["collection"] == "projects"
    trail << [page["title"], "#{id[:base]}#{page['url']}"]
    {
      "@type" => "BreadcrumbList",
      "itemListElement" => trail.each_with_index.map do |(name, url), i|
        { "@type" => "ListItem", "position" => i + 1, "name" => name, "item" => url }
      end,
    }
  end

  def page_node(site, page, id)
    url = "#{id[:base]}#{page['url']}"
    home = page["url"] == "/"
    node = {
      "@type" => "WebPage",
      "@id" => "#{url}#webpage",
      "url" => url,
      "name" => home ? full_name(site) : "#{page['title']} | #{full_name(site)}",
      "description" => page["meta_description"] || page["description"] || site.config["description"],
      "inLanguage" => "en-US",
      "isPartOf" => { "@id" => id[:website] },
      "about" => { "@id" => id[:person] },
    }
    if home
      node["@type"] = "ProfilePage"
      node["mainEntity"] = { "@id" => id[:person] }
      node["dateModified"] = site.time.iso8601
    elsif page["url"] == "/publications/"
      node["@type"] = "CollectionPage"
      node["hasPart"] = (site.data["papers"] || []).map { |p| work(site, p, id) }
    elsif page["collection"] == "projects"
      node["about"] = {
        "@type" => "ResearchProject",
        "name" => page["title"],
        "description" => page["description"],
        "parentOrganization" => { "@id" => id[:lab] },
        "member" => [{ "@id" => id[:person] }, { "@id" => id[:ferre] }],
      }
    end
    node["breadcrumb"] = breadcrumb(site, page, id) unless home || page["title"].to_s.empty?
    node
  end

  # One paper or presentation. Evan and Dr. Ferre point to their full entries; lab co-authors get the
  # link from _data/coauthors.yml.
  def work(site, paper, id)
    node = {
      "@type" => paper["type"] == "inproceedings" ? "CreativeWork" : "ScholarlyArticle",
      "@id" => "#{id[:base]}/publications/##{paper['key']}",
      "name" => paper["title"],
      "author" => paper["authors"].map { |a| author(site, a, id) },
      "description" => paper["summary"],
      "abstract" => paper["abstract"],
    }
    case paper["type"]
    when "article"
      node["datePublished"] = paper["date"]
      node["isPartOf"] = { "@type" => "Periodical", "name" => paper["journal"] } if paper["journal"]
      node["pagination"] = paper["pages"]
      ids = []
      if paper["doi"]
        node["url"] = "https://doi.org/#{paper['doi']}"
        ids << { "@type" => "PropertyValue", "propertyID" => "DOI", "value" => paper["doi"] }
      end
      ids << { "@type" => "PropertyValue", "propertyID" => "PMID", "value" => paper["pmid"] } if paper["pmid"]
      node["identifier"] = ids unless ids.empty?
      # The same article on PubMed and on the free full-text copy (PubMed Central).
      copies = []
      copies << "https://pubmed.ncbi.nlm.nih.gov/#{paper['pmid']}/" if paper["pmid"]
      copies << paper["fulltext"] if paper["fulltext"]
      node["sameAs"] = copies unless copies.empty?
      node["isAccessibleForFree"] = true if paper["fulltext"]
    when "unpublished"
      node["creativeWorkStatus"] = paper["status"] == "review" ? "Under review" : "In preparation"
    when "inproceedings"
      node["genre"] = paper["note"]
      node["releasedEvent"] = {
        "@type" => "PublicationEvent",
        "name" => paper["booktitle"],
        "startDate" => paper["date"],
        "location" => paper["address"] && { "@type" => "Place", "name" => paper["address"] },
      }.compact
      if paper["poster"]
        node["associatedMedia"] = {
          "@type" => "MediaObject",
          "encodingFormat" => "application/pdf",
          "contentUrl" => "#{id[:base]}/assets/pdf/#{paper['poster']}",
        }
      end
    end
    node["subjectOf"] = { "@type" => "WebPage", "url" => paper["news"] } if paper["news"]
    node.compact
  end

  def author(site, name, id)
    first, last = name["first"], name["last"]
    if last == site.config["last_name"] && first.start_with?(site.config["first_name"].to_s[0].to_s)
      return { "@id" => id[:person] }
    end
    return { "@id" => id[:ferre] } if last == site.data.dig("schema", "ferre", "familyName")

    node = { "@type" => "Person", "name" => "#{first} #{last}" }
    known = (site.data.dig("coauthors", last.downcase) || []).find { |c| Array(c["firstname"]).include?(first) }
    node["url"] = known["url"] if known
    node
  end

  class Tag < Liquid::Tag
    def render(context)
      site = context.registers[:site]
      page = context.registers[:page]
      json = JSON.pretty_generate({ "@context" => "https://schema.org", "@graph" => StructuredData.graph(site, page) })
      %(<script type="application/ld+json">\n#{json.gsub('</', '<\/')}\n</script>)
    end
  end
end

Jekyll::Hooks.register :site, :post_read do |site|
  site.data["papers"] = StructuredData.papers(site)
end

Liquid::Template.register_tag("schema_graph", StructuredData::Tag)
