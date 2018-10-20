#Searching Processes
#Michael Zabawa
import Base.isless
import Base.print
import Base.isequal

######################################################

mutable struct Count
    comparision::Int64
    assignment::Int64
end
function compMade(c::Count)
    c.comparision = c.comparision + 1
end
function assignMade(c::Count, increase::Int64)
    c.assignment = c.assignment + increase
end
function getComp(c::Count)
    return(c.comparision)
end
function getAssignments(c::Count)
    return(c.assignment)
end
function print(c::Count)
    comps = getComp(c)
    assign = getAssignments(c)
    print("Comparisions: $comps, Assignments: $assign")
end

######################################################

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
function isless(a::Node, b::Node)#a is less than b
    if(a.keyWord < b.keyWord)
        return(true)
    else
        return(false)
    end
end

function isequal(a::Node, b::Node)#a is less than b
    if(a.keyWord == b.keyWord && a.count == b.count)
        return(true)
    else
        return(false)
    end
end

function print(a::Node)
    println(getWord(a),"\t", a.count)
end

####################################################

function unSortedSearch()
    graphArray = zeros(Int64, 27888,2)
    numbercomp = Int64(0)
    analysis = Count(0,0)
    infile = open("wordlist.txt", "r")
    temp = Node("", 1)
    wordList = Node[]
    push!(wordList, temp) #starts the array
    inList = false
    wordcount = Int64(0)
    @time for word in readlines(infile)

        if(word == "")#removes empty strings
            continue
        end
        if(isletter(word[1]))#checks to see if the word starts with a letter
            wordcount = wordcount +1
            inList = false #assume not in list
            numbercomp = 0
            word = lowercase(word) #convert to lowercase
            for node in wordList#check each node
                compMade(analysis)
                numbercomp = numbercomp + 1
                if(word == getWord(node))#if in list
                    increaseCount(node)#increase count
                    inList = true #found in list
                    break
                end
            end
            if(!inList)#if not in list
                assignMade(analysis, 1)
                temp = Node(word, 1) #fill temp node with word and 1
                push!(wordList, temp) #put in word list
                graphArray[length(wordList),2] = 0 #new length
            end
            graphArray[length(wordList),1] = graphArray[length(wordList),1] + numbercomp
            graphArray[length(wordList),2] = graphArray[length(wordList),2] + 1
        end
    end
    close(infile)
    popfirst!(wordList)
    head = sort(wordList)[1:10]
    tail = sort(wordList, rev = true)[1:10]
    for i in 1:10
        print(head[i], "\n")
    end
    for i in 1:10
        print(tail[i], "\n")
    end
    # outfile = open("unsortedgraph.txt", "w")
    # for i in 1:27887
    #     temp = graphArray[i,1]/graphArray[i,2]
    #     write(outfile, "$i , $temp \n")
    # end
    # close(outfile)
    print(analysis)
    print(wordcount)
#    return(wordList)
end

####################################################

function sortedSearch()
    analysis = Count(0,0)
    graphArray = zeros(Int64, 27888,2)
    numbercomp = Int64(0)
    infile = open("wordlist.txt", "r")
    temp = Node("", 1)
    wordList = Node[]
    push!(wordList, temp)
    inList = false
    @time for word in readlines(infile)
        if(word == "")
            continue
        end
        if(isletter(word[1])) #checks for puncuation
            numbercomp = 0
            inList = false #assume not in list
            word = lowercase(word) #convert to lowercase
            first = 1 #start of subset
            middle = 1 #midpoint
            last = length(wordList)#end of subset
            while(!inList && first <= last)
                compMade(analysis)
                numbercomp = numbercomp + 1
                middle = Int64(floor((first + last) / 2)) #midpoint to check
                if(word > getWord(wordList[middle]))
                    first = middle + 1 #update start of subset
                elseif(word < getWord(wordList[middle]))
                    last = middle - 1 #update end of subset
                else
                    inList = true
                    increaseCount(wordList[middle])
                end
            end #while searching
            if(!inList)
                assignMade(analysis, (1 + (length(wordList) - first)))
                temp = Node(word, 1)
                insert!(wordList, first, temp)
                graphArray[length(wordList),2] = 0 #new list size
            end #if not in list insert
            graphArray[length(wordList),1] = graphArray[length(wordList),1] + numbercomp
            graphArray[length(wordList),2] = graphArray[length(wordList),2] + 1
        end #if letter
    end #for word
    close(infile)
    popfirst!(wordList)
    head = wordList[1:10]
    tail = reverse!(wordList)[1:10]
    for i in 1:10
        print(head[i], "\n")
    end
    for i in 1:10
        print(tail[i], "\n")
    end

    # outfile = open("sortedgraph.txt", "w")
    # for i in 1:27887
    #     temp = graphArray[i,1]/graphArray[i,2]
    #     write(outfile, "$i , $temp \n")
    # end
    # close(outfile)

    print(analysis)
    #return(wordList)
end #function

####################################################
#https://cp-algorithms.com/string/string-hashing.html
function hashMap(s::AbstractString)#not a good hash Not sure why but most elements hash to same value
    hashValue = Int(0)
    p = Int(31)
    m = Int(100000)
    p_pow = Int(1)
    for i in length(s)
        hashValue = (hashValue + ( Int(s[i]) - Int("a") + 1 ) * p_pow)
        p_pow = (p_pow * p)% m
    end
    return abs(hashValue % 100000) + 1
end

function hashSearch()
    analysis = Count(0,0)
    setup_temp = Node("", 0)
    tempArray = Node[]
    push!(tempArray, setup_temp)
    hashTable = Array{Array{Node,1}}(undef, 100000)
    for i in 1:100000
        hashTable[i] = deepcopy(tempArray)
    end

    index = Int64(1)
    collision = Int64(0)
    found = false
    infile = open("wordlist.txt", "r")
    @time for word in readlines(infile)
        if (word == "")
           continue
        end
        if (isletter(word[1]))
            found = false
            word = lowercase(word)
            index = Int64(hash(word) % 100000)
            for node in hashTable[index]
                compMade(analysis)
                if(getWord(node) == word)
                    found = true
                    increaseCount(node)
                    break
                end
            end
            if(!found)
                assignMade(analysis, 1)
                temp = Node(word, 1)
                if(isequal(hashTable[index][1],setup_temp))
                    hashTable[index][1] = temp
                else
                    collision = collision + 1
                    push!(hashTable[index], temp)
                end
            end
        end
    end
    finalArray = Node[]
    for nodeArray in hashTable
        if(!(isequal(nodeArray[1],setup_temp)))
            append!(finalArray, nodeArray)
        end
    end
    head = sort(finalArray)[1:10]
    tail = sort(finalArray, rev = true)[1:10]
    for i in 1:10
        print(head[i], "\n")
    end
    for i in 1:10
        print(tail[i], "\n")
    end
    close(infile)
    print(analysis)
    print(" Collisions: $collision ")
    return(hashTable)
end

testArray = ["A", "i", "e", "b", "c",  "f", "d", "g", "h", "a", "b"]
