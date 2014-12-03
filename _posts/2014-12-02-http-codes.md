---
name: http-codes
layout: post
title: http codes
date: 2014-12-02T16:01:50Z
author: Scott Chamberlain
tags:
- R
- API
- http
---



Recently noticed a little Python library called [httpcode](https://github.com/rspivak/httpcode) that does a simple thing: gives information on http codes in the CLI. I thought this could maybe potentially be useful for R. So I made an R version. 

## Installation


```r
devtools::install_github("sckott/httpcode")
```


```r
library("httpcode")
```

## Search by http code


```r
http_code(100)
#> <Status code: 100>
#>   Message: Continue
#>   Explanation: Request received, please continue
```


```r
http_code(400)
#> <Status code: 400>
#>   Message: Bad Request
#>   Explanation: Bad request syntax or unsupported method
```


```r
http_code(503)
#> <Status code: 503>
#>   Message: Service Unavailable
#>   Explanation: The server cannot process the request due to a high load
```


```r
http_code(999)
#> Error: No description found for code: 999
```

## Fuzzy code search


```r
http_code('1xx')
#> [[1]]
#> <Status code: 100>
#>   Message: Continue
#>   Explanation: Request received, please continue
#> 
#> [[2]]
#> <Status code: 101>
#>   Message: Switching Protocols
#>   Explanation: Switching to new protocol; obey Upgrade header
#> 
#> [[3]]
#> <Status code: 102>
#>   Message: Processing
#>   Explanation: WebDAV; RFC 2518
```


```r
http_code('3xx')
#> [[1]]
#> <Status code: 300>
#>   Message: Multiple Choices
#>   Explanation: Object has several resources -- see URI list
#> 
#> [[2]]
#> <Status code: 301>
#>   Message: Moved Permanently
#>   Explanation: Object moved permanently -- see URI list
#> 
#> [[3]]
#> <Status code: 302>
#>   Message: Found
#>   Explanation: Object moved temporarily -- see URI list
#> 
#> [[4]]
#> <Status code: 303>
#>   Message: See Other
#>   Explanation: Object moved -- see Method and URL list
#> 
#> [[5]]
#> <Status code: 304>
#>   Message: Not Modified
#>   Explanation: Document has not changed since given time
#> 
#> [[6]]
#> <Status code: 305>
#>   Message: Use Proxy
#>   Explanation: You must use proxy specified in Location to access this resource.
#> 
#> [[7]]
#> <Status code: 306>
#>   Message: Switch Proxy
#>   Explanation: Subsequent requests should use the specified proxy
#> 
#> [[8]]
#> <Status code: 307>
#>   Message: Temporary Redirect
#>   Explanation: Object moved temporarily -- see URI list
#> 
#> [[9]]
#> <Status code: 308>
#>   Message: Permanent Redirect
#>   Explanation: Object moved permanently
```


```r
http_code('30[12]')
#> [[1]]
#> <Status code: 301>
#>   Message: Moved Permanently
#>   Explanation: Object moved permanently -- see URI list
#> 
#> [[2]]
#> <Status code: 302>
#>   Message: Found
#>   Explanation: Object moved temporarily -- see URI list
```


```r
http_code('30[34]')
#> [[1]]
#> <Status code: 303>
#>   Message: See Other
#>   Explanation: Object moved -- see Method and URL list
#> 
#> [[2]]
#> <Status code: 304>
#>   Message: Not Modified
#>   Explanation: Document has not changed since given time
```

## Search by text message


```r
http_search("request")
#> [[1]]
#> <Status code: 100>
#>   Message: Continue
#>   Explanation: Request received, please continue
#> 
#> [[2]]
#> <Status code: 200>
#>   Message: OK
#>   Explanation: Request fulfilled, document follows
#> 
#> [[3]]
#> <Status code: 202>
#>   Message: Accepted
#>   Explanation: Request accepted, processing continues off-line
#> 
#> [[4]]
#> <Status code: 203>
#>   Message: Non-Authoritative Information
#>   Explanation: Request fulfilled from cache
#> 
#> [[5]]
#> <Status code: 204>
#>   Message: No Content
#>   Explanation: Request fulfilled, nothing follows
#> 
#> [[6]]
#> <Status code: 306>
#>   Message: Switch Proxy
#>   Explanation: Subsequent requests should use the specified proxy
#> 
#> [[7]]
#> <Status code: 400>
#>   Message: Bad Request
#>   Explanation: Bad request syntax or unsupported method
#> 
#> [[8]]
#> <Status code: 403>
#>   Message: Forbidden
#>   Explanation: Request forbidden -- authorization will not help
#> 
#> [[9]]
#> <Status code: 408>
#>   Message: Request Timeout
#>   Explanation: Request timed out; try again later.
#> 
#> [[10]]
#> <Status code: 409>
#>   Message: Conflict
#>   Explanation: Request conflict.
#> 
#> [[11]]
#> <Status code: 413>
#>   Message: Request Entity Too Large
#>   Explanation: Entity is too large.
#> 
#> [[12]]
#> <Status code: 414>
#>   Message: Request-URI Too Long
#>   Explanation: URI is too long.
#> 
#> [[13]]
#> <Status code: 416>
#>   Message: Requested Range Not Satisfiable
#>   Explanation: Cannot satisfy request range.
#> 
#> [[14]]
#> <Status code: 503>
#>   Message: Service Unavailable
#>   Explanation: The server cannot process the request due to a high load
#> 
#> [[15]]
#> <Status code: 505>
#>   Message: HTTP Version Not Supported
#>   Explanation: Cannot fulfill request.
```


```r
http_search("forbidden")
#> [[1]]
#> <Status code: 403>
#>   Message: Forbidden
#>   Explanation: Request forbidden -- authorization will not help
```


```r
http_search("too")
#> [[1]]
#> <Status code: 413>
#>   Message: Request Entity Too Large
#>   Explanation: Entity is too large.
#> 
#> [[2]]
#> <Status code: 414>
#>   Message: Request-URI Too Long
#>   Explanation: URI is too long.
```


```r
http_search("birds")
#> Error: No status code found for search: : birds
```
