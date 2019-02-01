#include "stdio.h"
#include "stdlib.h"
#include <fstream>

using namespace std;

#define DEGREE_TO_NDS(degree) (degree * (1UL << 32) / 360)
#define NDS_TO_DEGREE(nds) (nds * 360 / (1UL << 32))


struct Position
{
    int longitude;
    int latitude;
};

char GetLvl(unsigned int	ulTileID)
{
	char level;

	ulTileID >>= 16;
	level = (-1);
	while( ulTileID )
	{
		level++;
		ulTileID >>= 1;
	}

	return level;
}

void CalcMortonCode(long long & mortonCode, int x, int y)
{
	mortonCode = 0;

	unsigned int longitude = (unsigned int)x;
	unsigned int latitude  = (unsigned int)y & 0x7FFFFFFF;

	int i = 0;
	while(i < 64)
	{
		long long x = longitude & 0x01;
		long long y = latitude & 0x01;
		longitude >>= 1;
		latitude >>= 1;

		mortonCode |= x<<i;
		i++;
		mortonCode |= y<<i;
		i++;
	}
}

int CalcPackedTileIdByPosition( const Position *Position, int Level, unsigned int *PackedTileId )
{
	long long m = 0;
	CalcMortonCode( m, Position->longitude, Position->latitude);
	*PackedTileId = (0x1<<( 16 + Level )) + (m >> ( 64 - ( (Level + 1) * 2 ) ) );
	return 0;
}

#define	_TILE_WIDTH_(_level_)		(1UL<<(31-(_level_)))

int CalcSouthWestPositionOfTile( unsigned int packedTileId, Position *Position )
{
	unsigned long lv;
	unsigned long width, pos, id;
	int n;
	unsigned long lon, lat;

    lv = GetLvl(packedTileId);
	printf("lvl = %d\n", lv);
	width = _TILE_WIDTH_( lv );

	id = packedTileId - (1UL << (lv+16));

	lon = 0;
	lat = 0;

	for( n = (int)lv; n >= 0; n-- ){

		pos = id & 0x3;
		if( n == 1 ){
			pos ^= 0x2;
		}

		if( pos & 0x1 ){
			lon += width;
		}
		if( pos & 0x2 ){
			lat += width;
		}

		id >>= 2;

		width <<= 1;
	}

	if( Position ){
		Position->longitude = (long long)lon;
		Position->latitude  = (long long)lat - (0x1<<30);
	}
	printf("lat= %d, lon = %d\n", Position->latitude, Position->longitude);
	printf("lat= %f, lon = %f\n", NDS_TO_DEGREE((double)Position->latitude), NDS_TO_DEGREE((double)Position->longitude));
	return 0;
}

int main()
{
	Position p = {0};
	int mesh_id = 20596632 + (1UL << 29);
	CalcSouthWestPositionOfTile(mesh_id, &p);
    size_t flag_rows = 1;
    size_t flag_columns = 2;
    const double lat = -90;
    const double lon = -180;
	::std::ofstream oss("tile_id.txt");
//	for( size_t lvl = 0; lvl < 16; lvl++)
//  {
	size_t lvl = 1;
		oss << "level : " << lvl << ::std::endl;

		size_t rows = flag_rows * (1UL << lvl);
		size_t columns = flag_columns * (1UL << lvl);
    	printf("rows = %d, columns = %d\n", rows, columns);    
        for (size_t row = 0; row < rows; row++)
        {
            const double lat_width = 180 / rows;
            const double lon_width = 360 / columns;
			oss << "tile id : " ;
            for (size_t column = 0; column < columns; column++)
            {
                double element_lat = lat + lat_width * row;
                double element_lon = lon + lon_width * column;
//		element_lat = 476577792;
//		element_lon = 1389363200;
				// double element_lat = 40.689167;
                // double element_lon = -74.044444;
                Position position;
                position.latitude = DREGEE_TO_NDS(element_lat);
                position.longitude = DREGEE_TO_NDS(element_lon);
		printf("lat = %d, lon = %d\n", position.latitude, position.longitude);
                unsigned int tile_id = 0;
                CalcPackedTileIdByPosition(&position, 13, &tile_id);
				oss << " " << tile_id << " " ;
            } 
			oss << ::std::endl;

        }

    //}
    
    return 0;
}
