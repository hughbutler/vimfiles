module MailTemplatesHelper

  def to_html(string)
    string.gsub("\n", "<br/>").html_safe
  end

  def render_mail_template(context)
    MailTemplate.by_community(community_id).context(context).first.blurb
  end
end
