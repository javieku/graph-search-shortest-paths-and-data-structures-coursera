#include <algorithm>
#include <fstream>
#include <iostream>
#include <numeric>
#include <sstream>
#include <string>
#include <tuple>
#include <unordered_map>
#include <vector>

class SearchIndex
{
public:
    SearchIndex( std::vector< int64_t > data )
    {
        m_data = std::move( data );
		std::sort(m_data.begin(), m_data.end());

        for ( int64_t x : m_data )
        {
            m_index[ x ] = true;
        }
    }

    bool
    look_up( int64_t t )
    {
        for ( int64_t x : m_data )
        {
            int64_t y = t - x;
            auto it = m_index.find( y );
            if ( it != m_index.end( ) && x != y )
            {
                return true;
            }
        }
        return false;
    }

private:
    std::unordered_map< int64_t, bool > m_index;
    std::vector< int64_t > m_data;
};

std::vector< int64_t >
read_file( const std::string& file_path )
{
    std::ifstream infile( file_path );
    std::string line;
    std::vector< int64_t > data;
    data.reserve( 1000000 );
    while ( std::getline( infile, line ) )
    {
        std::istringstream iss( line );
        int64_t n;
        if ( !( iss >> n ) )
        {
            break;
        }  // error
        data.push_back( n );
    }
    return data;
}

int
main( )
{
    SearchIndex index( read_file( "hw.txt" ) );

    int32_t counter = 0;
    for ( int64_t t = -10000; t <= 10000; t++ )
    {
        if ( index.look_up( t ) )
        {
            counter++;
        }
    }

    std::cout << counter;
    std::string s;
    std::cin >> s;
    return 0;
}

