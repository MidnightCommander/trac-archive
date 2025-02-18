#include <string>
#include <iostream>
#include <cstdlib>
#include <cstdio>
#include <strings.h>
#include <clocale>
#include <langinfo.h>
//#include <sys/param.h>

std::wstring To16Char(const std::string &asString)
{
	std::wstring wsTemp;
	size_t needed = std::mbstowcs(NULL, &asString[0],0);
	wsTemp.resize(needed);
	std::mbstowcs(&wsTemp[0],&asString[0],needed);

	return wsTemp;
}

//-----------------------------------------------------------------------

std::string To8Char(const std::wstring &awsString)
{
	std::string sTemp;
	size_t needed = std::wcstombs(NULL,&awsString[0],0);
	sTemp.resize(needed);
	std::wcstombs(&sTemp[0],&awsString[0],needed);

	return sTemp;
}

void ReadFile(std::string asFile)
{
	FILE *fp = fopen(asFile.c_str(),"r");
	if (fp) {
		char str[1024];
		fgets(str, 1024, fp);
		printf("File: %s Contents: %s\n", asFile.c_str(), str);
		fclose(fp);
	} else {
		std::cerr << "Error opening file:" << asFile << std::endl;
	}
}


int main (int argc, const char* const argv[])
{
	if(!std::setlocale(LC_CTYPE, "")) {
		std::cerr << "Can't set the specified locale! Check LANG, LC_CTYPE, LC_ALL." << std::endl;
		return 1;
	}
	char *charset = nl_langinfo(CODESET);
	bool utf8_mode = (strcasecmp(charset, "UTF-8") == 0);
	std::cerr << "UTF-8 Charset "
			<< std::string(utf8_mode ? "is" : "not")
			<< " available.\nCurrent LANG is " << std::string(getenv("LANG"))
			<< "\nCharset: " << charset <<"\n";

	std::string utf8 = "Hämtningar";
	std::cout << "This is a UTF-8 Conversion Test" << std::endl;
	
	std::wstring utf32 = L"";
	
	std::cout << "Initial UTF-8 " << utf8 << std::endl;
	utf32 = To16Char(utf8);
	
	printf("UTF-32 Version: '%ls'\n", utf32.c_str());
	
	utf8 = To8Char(utf32);
	
	printf("UTF-8 Again: '%s'\n", utf8.c_str());

#ifdef TESTFILE
	ReadFile("test.txt");

	char rpath[PATH_MAX];
	realpath("test.txt", rpath);
	printf("Full Path: %s\n",rpath);
	ReadFile(rpath);
	
	realpath(To8Char(L"test.txt").c_str(),rpath);
	utf32 = To16Char(rpath);
	printf("Full Path: %ls\n", utf32.c_str());
	utf8 = To8Char(utf32);
	printf("Full Path(8): %s\n",utf8.c_str());
	ReadFile(utf8.c_str());
#endif
	return 0;
}

// vim: set noet ts=4:
