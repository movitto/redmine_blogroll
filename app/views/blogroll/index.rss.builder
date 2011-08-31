xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title @project.name
    xml.description @project.description
    xml.link url_for(:controller => :blogroll, :action => :index, :format => :rss, :project_id => @project.identifier)

    for c in @content
      xml.item do
        xml.title c.title
        xml.description c.content
        xml.pubDate c.date.to_s(:rfc822)
        xml.link c.link
      end
    end
  end
end
