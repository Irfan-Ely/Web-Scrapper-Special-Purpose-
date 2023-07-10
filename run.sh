#!/bin/bash

clear

echo
echo "                  *-(+)-* DATA ENTRY PROGRAM *-(+)-*"
echo
echo "              Program Used Guide"
echo " [+] Their are Four Parameter are required to run the program correctly ."
echo " [+] 1st Parameter is the Starting Serial-# for Excel-Sheet."
echo " [+] 2nd Parameter is the Starting Serial-# for Book."
echo " [+] 3rd Parameter is the Name and location of the Excel File for output."
echo " [+] 4th Parameter is the Name of the input file."
echo " [+] 5th Parameter is used to decide the inclusion Field-Name [ Y or N ]."
echo " [+] 6th Parameter is used to line number of input file."
echo 
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo
sleep 1s
clear
sn=$1 
bsn=$2
fname=$3
ifilename=$4
field_option=$5
lineno=$6
heading=$(cat<<mh

from bs4 import BeautifulSoup 
import requests 
import csv 
import webbrowser
serial_no=int("$sn")
book_serial_no=int("$bsn")
record_check={}
print("\t             *-(+)-* Developer : Irfan ali *-(+)-*")  
	
mh
)


data=$(cat<<iab


def s_to_n(opt):
    inp_str = str(opt)
    num = ""
    for c in inp_str:
        if c.isdigit():
            num = num + c
    return num
# field names 
# data rows of csv file 
tablefields = ['S.No', 'ISBN', 'Title', 'Author','Edition','Year of Publish',"Subject","E-Book S.No"] 
a="$fname"
csvfile=open(a, 'a', newline='')
mwriter = csv.writer(csvfile, delimiter=' ')
if "$field_option"=="y" or "$field_option"=="Y":
        mwriter.writerow(tablefields)
else:
        pass
        
        
iab
)

inputfile=$(cat<<ifile

file1 = open("$ifilename", 'r')
Lines = file1.readlines()
data_line=[]
# Strips the newline character
for line in Lines:
	data_line.append(line)
ifile
)
data1=$(cat<<iab1

lno=int($lineno)
if(lno<len(data_line)):
	count=lno
else:
	count=0

while count<len(data_line):
	print("\a")
	print("[+] ISBN-# : ",data_line[count],end='')
	isbn=data_line[count]
	book_row_record=['','','','','','','','']
	req_data=['','','','','','']
	if(len(isbn)>2):
		try:
				firsturl ="http://classify.oclc.org/classify2/ClassifyDemo?search-standnum-txt="+isbn+"&startRec=0"
				mainpage=requests.get(firsturl) 
				#webbrowser.open(firsturl, new=0)
				sm=BeautifulSoup(mainpage.content,'html.parser')
				m_section=str(sm.find('dd',class_='goLeft'))
				mainpageurl=str(sm.find("td",class_="ta"))
				if(len(m_section)>5):
					print("[Visit-URL]:",firsturl)
				else:
					mainpageurl=mainpageurl.replace('<td class="ta"><span class="title"><a href=','')
					mainpageurl=mainpageurl.split(">")
					mainpageurl=mainpageurl[0].split('"')
					mainpageurl=mainpageurl[1]
					mainpageurl="http://classify.oclc.org"+mainpageurl		
					firsturl=mainpageurl
					print("[Visit-URL]:",firsturl)
		
		except:
			print("[%] OOP's ! Invalid ISBN....@")
			isbn=''			
		url1=firsturl
		page=requests.get(url1) 
		s1=BeautifulSoup(page.content,'html.parser')
		fnb=str(s1.find_all("dd",class_="goLeft"))
		fnb=fnb.replace('<dd class="goLeft">','')
		fnb=fnb.replace('</span>','')
		fnb=fnb.replace('</dd>','')
		fnb=fnb.replace(">",'')
		fnb=fnb.split('<span')

		fanb=str(s1.find_all('span',class_="itemtype"))
		fanb=fanb.replace('class="itemtype itemtype-book"','')
		fanb=fanb.replace('class="itemtype itemtype-compfile-digital"','')
		fanb=fanb.replace('class="itemtypeitemtype-book"','')
		fanb=fanb.replace('</span>','')
		fanb=fanb.replace('title="','')
		fanb=fanb.replace(' ','')
		fanb=fanb.replace('class="itemtypeitemtype-book-digital"','')
		fanb=fanb.replace('\xa0','')
		fanb=fanb.replace(' ','')
		fanb=fanb.replace('</dd>','')
		fanb=fanb.replace(">",'')
		fanb=fanb.replace('"','')
		fanb=fanb.replace(',','')
		fanb=fanb.split('<span')
		iab10=0
		ftitle=0
		bai=iab10
		iab10=len(fnb)
		bai=iab10
		while iab10<len(fanb):
			if(fanb[iab10]=='Book'):
				ftitle=iab10-bai
				break
			else:
				pass
			iab10=iab10+1
		tlink=str(s1.find_all("a",class_="titlelink"))
		tlink=str(s1.find_all("a",class_="titlelink"))
		tlink=tlink.replace('<a class="titlelink"','')
		tlink=tlink.replace('target="_blank">','')
		tlink=tlink.replace('</a>','')
		tlink=tlink.replace("href='",'')
		tlink=tlink.split('"')
		checkstr=''
		try:
			surl=tlink[2*ftitle+1]
			#* pip install beautifulsoup4
			page=requests.get(surl) 
			s=BeautifulSoup(page.content,'html.parser')
			checkstr=str(s)
			#***************/

		except:
			print("[%] OOP's ! Invalid URL....@")
			surl=''
		if(len(checkstr)>10):
			try:
				title=s.find('h1',class_="title").text
			except:
				print("[%] Sory ! B-Title Not Mentioned....@")
				title=''
		#	try:	
		#		summary=s.find('p',class_="nielsen-review")
		#		print(summary)
		#	except:	
		#		print("[%] Sory ! Summary Not Mentioned....@")
		#		summary=''            
			try:
				author=s.find('td',id="bib-author-cell").text
			except:
				print("[%] Sory ! Author Name Not Mentioned....@")
				author=''
			try:				    
				edition=str(s.find('span',class_="bks",id="editionFormatType"))
				edition=edition.replace('<span class="bks" id="editionFormatType">','')
				edition=edition.replace('<img alt=" " class="icn" height="16" src="/wcpa/rel20220204/images/icon-bks.gif" width="16"/> <span class="itemType">Print book</span>','')
				edition=edition.replace('</span>','')
				edition=edition.replace('edition<a class="vieweditions" href="/oclc/34128269/editions?editionsView=true&amp;referer=di">View all editions and formats</a>','')
				edition=edition.split('<a')
				edition=str(edition[0])
				edition=s_to_n(edition)
				print(edition)
			except:
				pass
			try:
				subject=str(s.find("ul",id="subject-terms").text)
				subject=subject.replace("View all subjects","")
				subject=subject.replace(".",", ")
			except:
				print("[%] Sory ! Subject Name Not Mentioned....@")
				subject=''   
			try:
				if(edition):
					pass
				else:
					edi=s1.find_all('dd',class_="goLeft")
					edition=s_to_n(edi)
			except:
				print("[%] Sory ! Book-Edition Not Mentioned....@") 
				edition=''
			try:
				published_year=s.find_all("td",id="bib-publisher-cell")
				req_data=[isbn,title,author,subject,published_year,edition]
				req_data[4]=s_to_n(req_data[4])
			except:
				print("[%] Sory ! Published Year Not Mentioned....@")
				published_year=''
			else:
				book_row_record[0]=serial_no
				book_row_record[1]=isbn
				book_row_record[2]=''
				book_row_record[3]=''
				book_row_record[4]=''
				book_row_record[5]=''
				book_row_record[6]=''
				book_row_record[7]=book_serial_no		
		book_row_record=[serial_no,req_data[0],req_data[1],req_data[2],req_data[5],req_data[4],req_data[3],book_serial_no]
		book_row_record[6]= book_row_record[6].replace("\n",'')
		book_row_record[3]= book_row_record[3].replace(";",', ')
	else:
		book_row_record[0]=serial_no
		book_row_record[1]=isbn
		book_row_record[2]=''
		book_row_record[3]=''
		book_row_record[4]=''
		book_row_record[5]=''
		book_row_record[6]=''
		book_row_record[7]=book_serial_no		
	record_check={
		'Serail_no':book_row_record[0],
		'ISBN_no':book_row_record[1],
		"Title":book_row_record[2],
		"Author":book_row_record[3],
		"Edition":book_row_record[4],
		"Y_o_ublish":book_row_record[5],
		"Subject":book_row_record[6],
			"B_Serial_no":book_row_record[7]
	}
	       
	mwriter.writerow(book_row_record)
	for key, value in record_check.items():
		print('[-]',key,' : ',record_check[key])
	print("\n\t     Record Successfully Inserted ...") 
	print("\n\t    <==================================================>") 
	        # else:
	        #     print("[+] Something Went Wrong !@")
        #     print("[+] Try New Entry .")
	serial_no=serial_no+1
	book_serial_no=book_serial_no+1
	count=count+1	
	#   # for a single subject name
	#     # for list in subject:
	#     #     fat=list.find("li",class_="subject-term").text
	#     #     print(fat)
	#     # for a subject title name
	# # print("ISBN-#:",req_data[0])
	# # print("Title:",req_data[1])
	# # print("Author:",req_data[2])
	# # print("Subject:",req_data[3])
	# # print("Edition:",req_data[5])
	# # print("Published_Year:",req_data[4])
	
iab1
)


python3 -c "$heading $inputfile $data $data1 "
#clear

