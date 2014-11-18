package integration

import (
	"bytes"
	"encoding/json"
	"net/http"
	"time"
	influxdb "github.com/influxdb/influxdb/client"
	. "gopkg.in/check.v1"
)

type DataTestClient struct {
	db string
}

func (self *DataTestClient) CreateDatabase(db string, c *C) {
	client, err := influxdb.NewClient(&influxdb.ClientConfig{})
	c.Assert(err, IsNil)
	c.Assert(client.CreateDatabase(db), IsNil)
}

func (self *DataTestClient) SetDB(db string) {
	self.db = db
}

func (self *DataTestClient) WriteData(series []*influxdb.Series, c *C, timePrecision ...influxdb.TimePrecision) {
	client, err := influxdb.NewClient(&influxdb.ClientConfig{
	Database: self.db,
	HttpClient: &http.Client{
	Timeout: 60 * time.Second,
},
})
	c.Assert(err, IsNil)
	if len(timePrecision) == 0 {
		c.Assert(client.WriteSeries(series), IsNil)
	} else {
		c.Assert(client.WriteSeriesWithTimePrecision(series, timePrecision[0]), IsNil)
	}
}

func (self *DataTestClient) WriteJsonData(seriesString string, c *C, timePrecision ...influxdb.TimePrecision) {
	series := []*influxdb.Series{}
	decoder := json.NewDecoder(bytes.NewBufferString(seriesString))
	decoder.UseNumber()
	err := decoder.Decode(&series)
	c.Assert(err, IsNil)
	self.WriteData(series, c, timePrecision...)
}

func (self *DataTestClient) RunQuery(query string, c *C, timePrecision ...influxdb.TimePrecision) []*influxdb.Series {
	client, err := influxdb.NewClient(&influxdb.ClientConfig{Database: self.db})
	c.Assert(err, IsNil)
	series, err := client.Query(query, timePrecision...)
	c.Assert(err, IsNil)
	return series
}

func (self *DataTestClient) RunQueryWithNumbers(query string, c *C, timePrecision ...influxdb.TimePrecision) []*influxdb.Series {
	client, err := influxdb.NewClient(&influxdb.ClientConfig{Database: self.db})
	c.Assert(err, IsNil)
	series, err := client.QueryWithNumbers(query, timePrecision...)
	c.Assert(err, IsNil)
	return series
}

func (self *DataTestClient) RunInvalidQuery(query string, c *C, timePrecision ...influxdb.TimePrecision) []*influxdb.Series {
	client, err := influxdb.NewClient(&influxdb.ClientConfig{Database: self.db})
	c.Assert(err, IsNil)
	_, err = client.Query(query, timePrecision...)
	c.Assert(err, NotNil)
	return nil
}

func (self *DataTestClient) DeleteDatabase(db string, c *C) {
	client, err := influxdb.NewClient(&influxdb.ClientConfig{})
	c.Assert(err, IsNil)
	c.Assert(client.DeleteDatabase(db), IsNil)
}
type ApiSeries interface {
	GetName() string
	GetColumns() []string
	GetPoints() [][]interface{}
}
func ToMap(series ApiSeries) []map[string]interface{} {
	seriesPoints := series.GetPoints()
	points := make([]map[string]interface{}, 0, len(seriesPoints))
	for _, p := range seriesPoints {
		point := map[string]interface{}{}
		for idx, column := range series.GetColumns() {
			point[column] = p[idx]
		}
		points = append(points, point)
	}
	return points
}
