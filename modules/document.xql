xquery version "3.0";

module namespace document="http://dhil.lib.sfu.ca/exist/wilde-app/document";

import module namespace console="http://exist-db.org/xquery/console";
import module namespace functx='http://www.functx.com';

import module namespace config="http://dhil.lib.sfu.ca/exist/wilde-app/config" at "config.xqm";

declare namespace xhtml='http://www.w3.org/1999/xhtml';
declare default element namespace "http://www.w3.org/1999/xhtml";

declare function document:id($node as node()) as xs:string {
    let $id := root($node)/html/@id
    return if(empty($id)) then ''
    else
        $id
};

declare function document:title($node as node() ) as xs:string {
    let $title := normalize-space(root($node)//title/string())
    return 
    if(string-length($title) gt 1) then
        $title
    else
        "(unknown title)" 
};

declare function document:subtitle($node as node()) as xs:string {
    string(root($node)//body/p[1])
};

declare function document:path($node as node()) as xs:string {
  string(root($node)//meta[@name='wr.path']/@content)
};

declare function document:word-count($node as node()) as xs:string {
    string(root($node)//meta[@name='wr.wordcount']/@content)
};

declare function document:date($node as node()) as xs:string {
    string(root($node)//meta[@name='dc.date']/@content)
};

declare function document:publisher($node as node()) as xs:string {
    string(root($node)//meta[@name='dc.publisher']/@content)
};

declare function document:edition($node as node()) as xs:string {
    string(root($node)//meta[@name='dc.publisher.edition']/@content)
};

declare function document:region($node as node()) as xs:string {
    string(root($node)//meta[@name='dc.region']/@content)
};
(: stopped here. :)
declare function document:document-matches($node as node()) as node()* {
    root($node)//link[@rel='similarity']
};

declare function document:paragraph-matches($node as node()) as node()* {
    root($node)//div[@id='original']//a[contains(@class, 'similarity')]
};

declare function document:city($node as node()) as xs:string {
  let $cities := root($node)//meta[@name='dc.region.city']/@content
  return
    if(count($cities) > 1) then
      string($cities[1])
    else
      string(root($node)//meta[@name='dc.region.city']/@content)
};

(: Stopped unit testing here. :)

declare function document:source($node as node()) as xs:string* {
  root($node)//meta[@name='dc.source']/@content/string()
};

declare function document:source-institution($node as node()) as xs:string* {
  root($node)//meta[@name='dc.source.institution']/@content/string()
};

declare function document:source-url($node as node()) as xs:string* {
  root($node)//meta[@name='dc.source.url']/@content
};

declare function document:source-database($node as node()) as xs:string* {
  root($node)//meta[@name='dc.source.database']/@content
};

declare function document:facsimile($node as node()) as xs:string* {
  for $uri in root($node)//meta[@name='dc.source.facsimile']/@content
  return $uri
};

declare function document:language($node as node()) as xs:string {
  let $languages := root($node)//meta[@name='dc.language']/@content
  return 
    if(count($languages) > 1) then
        $languages[1]
    else
      string(root($node)//meta[@name='dc.language']/@content)
};

declare function document:translations($node as node()) as xs:string* {
  root($node)//div[@class='translation']/@lang/string()
};

declare function document:count-translations($node as node()) as xs:integer {
  count(root($node)//div[@class='translation'])
};

declare function document:indexed-document($node as node()) as xs:string* {
  let $node := root($node)//meta[@name="index.document"]
  return if($node) then $node/@content else "No"
};

declare function document:similar-documents($node as node()) as node()* {
    for $node in root($node)//link[@rel='similarity']
    order by $node/@data-similarity descending
    return $node
};

declare function document:indexed-paragraph($node as node()) as xs:string* {
  let $node := root($node)//meta[@name="index.paragraph"]
  return if($node) then $node/@content else "No"
};

declare function document:similar-paragraphs($node as node()) as node()* {
    for $node in root($node)//div[@id='original']//a[contains(@class, 'similarity')]
    order by $node/@data-similarity descending
    return $node
};
