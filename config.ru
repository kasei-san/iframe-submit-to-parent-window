require "rack"
require "uri"

class Test
  def call(env)
    path = env['PATH_INFO']
    @req = Rack::Request.new(env)
    case URI.parse(@req.url).path
    when '/'
      render(index_body)
    when '/index_search'
      render(index_search_body)
    when '/search'
      render(search_body)
    else
      [404, {'Content-Type' => 'text/html'}, []]
    end
  end

  def render(body)
    [200, {'content-type' => 'text/html'}, [header, body, footer]]
  end

  def header
    <<-EOS
      <html>
        <head>
          <script src="//ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
        </head>
        <body>
    EOS
  end

  def footer
    <<-EOS
        </body>
      </html>
    EOS
  end

  # index
  #
  def index_body
    <<-EOS
      <h1>index</h1>
      <iframe src="/index_search"></iframe>
    EOS
  end

  # index の iframe で表示される検索画面
  #
  def index_search_body
    <<-EOS
      <form action="/search" method="get" id="form">
        <input name="keyword" type="text" value="" />
        <input type="submit" value="検索" />
      </form>
      <script>
        $("form").submit(function(){
          window.parent.location.href = "/search?"+$("form").serialize();
          return false;
        });
      </script>
    EOS
  end

  # 検索結果
  #
  def search_body
    <<-EOS
    <div>#{@req['keyword']}</div>
    <form action="/search" method="get" id="form">
      <input name="keyword" type="text" value="#{@req['keyword']}" />
      <input type="submit" value="検索" />
    </form>
    EOS
  end
end

run Test.new
