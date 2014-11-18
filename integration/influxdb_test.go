package integration

import (
	"testing"
	"net/http"
	"io/ioutil"
	"github.com/bradfitz/iter"
	. "gopkg.in/check.v1"
)
func Test(t *testing.T) { TestingT(t) }

type DataTestSuite struct {
	client *DataTestClient
	dbname string
}

var _ = Suite(&DataTestSuite{})

func (self *DataTestSuite) SetUpSuite(c *C) {
	self.dbname = "testdb"
	http.DefaultTransport.(*http.Transport).CloseIdleConnections()
}

func (self *DataTestSuite) SetUpTest(c *C) {
	self.client = &DataTestClient{}
	self.client.CreateDatabase(self.dbname, c)
	self.client.SetDB(self.dbname)
}

func (self *DataTestSuite) TearDownTest(c *C) {
	self.client.DeleteDatabase(self.dbname, c)
	self.client = nil
}

func loadInstanceMetricTemplate(c *C) string{
	data, err := ioutil.ReadFile("test_data.json")
	c.Assert(err,IsNil)
	return string(data)
}

func (self *DataTestSuite) TestWriteItems(c *C) {
	data := loadInstanceMetricTemplate(c)
	entries := 10
	for _ = range iter.N(entries){
		self.client.WriteJsonData(data, c)
	}
	result := self.client.RunQuery("select count(trackingObjectId) from instance_metrics", c)
	maps := ToMap(result[0])
	c.Assert(maps[0]["count"], Equals, float64(entries))
}
