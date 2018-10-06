#Searching Processes
mutable struct Counter
    comparision::Int64

end
mutable struct Node
    keyWord::AbstractString
    count::Int64
end
function increaseCount(n::Node)
    n.count = n.count + 1
end
function getWord(n::Node)
    return(n.keyWord)
end

function unSortedSearch()
    infile = open("wordlist.txt", "r")
    temp = Node("", 1)
    wordList = Node[]
    push!(wordList, temp)
    inList = false
    for word in readlines(infile)
        if(word == "")
            continue
        end
        if(isletter(word[1]))
            inList = false #assume not in list
            word = lowercase(word) #convert to lowercase
            for i in eachindex(wordList)#check each node
                if(word == getWord(wordList[i]))#if in list
                    increaseCount(wordList[i])#increase count
                    inList = true #found in list
                end
            end
            if(!inList)#if not in list
                temp = Node(word, 1) #fill temp node with word and 1
                push!(wordList, temp) #put in word list
            end
        end
    end
    close(infile)
    popfirst!(wordList)
    head = sort(wordList)[1:10]
    tail = sort(wordList, rev = true)[1:10]
    println(head)
    println(tail)
    return(wordList)
end

function hashSearch()
    infile = open("wordlist.txt", "r")
    wordDic = Dict{String,Int64}()
    for word in readlines(infile)
        if (word == "")
           continue
        end
        if (isletter(word[1]))
            word = lowercase(word)
            if(word in keys(wordDic))
                wordDic[word] += 1
            else
                wordDic[word] = 1
            end
        end
    end
    close(infile)
    head = sort(collect(wordDic))[1:10]
    tail = sort(collect(wordDic), rev = true)[1:10]
    println(head)
    println(tail)
    return(wordDic)
end


function main()
    @time hashSearch()
end
