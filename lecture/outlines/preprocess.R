library(tm)

preprocess3 = function(x)
{
    result = tolower(x)
    stemDocument(result)
}
