should = require('chai').should()

{DataDetail} = require '../../src/data/data-detail'
{DataQuery2} = require '../../src/data/data-query2'

describe 'Data queries', ->

  it 'has the expected properties', ->
    q = DataQuery2.from {flow: 'ICP'}
    q.should.be.an 'object'
    q.should.have.property 'flow'
    q.should.have.property 'key'
    q.should.have.property 'updatedAfter'
    q.should.have.property 'firstNObs'
    q.should.have.property 'lastNObs'
    q.should.have.property 'obsDimension'
    q.should.have.property 'history'
    q.should.have.property 'attributes'
    q.should.have.property 'measures'

  it 'has the expected defaults', ->
    flow = 'EXR'
    q = DataQuery2.from {flow: flow}
    q.should.have.property('flow').that.equals flow
    q.should.have.property('key').that.equals 'all'
    q.should.have.property('updatedAfter').that.is.undefined
    q.should.have.property('firstNObs').that.is.undefined
    q.should.have.property('lastNObs').that.is.undefined
    q.should.have.property('obsDimension').that.is.undefined
    q.should.have.property('history').that.is.false
    q.should.have.property('attributes').that.equals 'dsd'
    q.should.have.property('measures').that.equals 'all'

  describe 'when setting the flow', ->

    it 'throws an exception when the flow is not set', ->
      test = -> DataQuery2.from({flow: ' '})
      should.Throw(test, Error, 'Not a valid data query')

      test = -> DataQuery2.from({flow: undefined})
      should.Throw(test, Error, 'Not a valid data query')

    it 'throws an exception when the flow is invalid', ->
      test = -> DataQuery2.from({flow: '1%'})
      should.Throw(test, Error, 'Not a valid data query')

  describe 'when setting the key', ->

    it 'a string representing the key can be used', ->
      flow = 'EXR'
      key = 'M.CHF.EUR.SP00.A'
      q = DataQuery2.from({flow: flow, key: key})
      q.should.have.property('flow').that.equals flow
      q.should.have.property('key').that.equals key

    it 'a string with wildcarded values can be used', ->
      flow = 'EXR'
      key = 'M.*.EUR.SP00.*'
      q = DataQuery2.from({flow: flow, key: key})
      q.should.have.property('flow').that.equals flow
      q.should.have.property('key').that.equals key

    it 'a string with multiple keys can be used', ->
      flow = 'EXR'
      key = 'M.CHF.EUR.SP00.A,D.CHF.EUR.SP00.A'
      q = DataQuery2.from({flow: flow, key: key})
      q.should.have.property('flow').that.equals flow
      q.should.have.property('key').that.equals key

    it 'throws an exception if the value for the key is invalid', ->
      test = -> DataQuery2.from({flow: 'EXR', key: 'M.CHF+NOK.EUR..'})
      should.Throw(test, Error, 'Not a valid data query')

  describe 'when setting the updatedAfter timestamp', ->

    it 'a string representing a timestamp can be passed', ->
      flow = 'EXR'
      last = '2016-03-04T09:57:00Z'
      q = DataQuery2.from({flow: flow, updatedAfter: last})
      q.should.have.property('flow').that.equals flow
      q.should.have.property('updatedAfter').that.equals last

    it 'throws an exception if the value for updatedAfter is invalid', ->
      test = -> DataQuery2.from({flow: 'EXR', updatedAfter: 'now'})
      should.Throw(test, Error, 'Not a valid data query')

      test = -> DataQuery2.from({flow: 'EXR', updatedAfter: '2000-Q1'})
      should.Throw(test, Error, 'Not a valid data query')

  describe 'when setting the first and last number of observations', ->

    it 'integers representing the desired number of obs can be passed', ->
      flow = 'EXR'
      firstN = 1
      lastN = 3
      q = DataQuery2.from({flow: flow, firstNObs: firstN, lastNObs: lastN})
      q.should.have.property('flow').that.equals flow
      q.should.have.property('firstNObs').that.equals firstN
      q.should.have.property('lastNObs').that.equals lastN

    it 'throws an exception if the value for firstObs is invalid', ->
      test = -> DataQuery2.from({flow: 'EXR', firstNObs: -2})
      should.Throw(test, Error, 'Not a valid data query')

      test = -> DataQuery2.from({flow: 'EXR', firstNObs: 'test'})
      should.Throw(test, Error, 'Not a valid data query')

    it 'throws an exception if the value for lastNObs is invalid', ->
      test = -> DataQuery2.from({flow: 'EXR', lastNObs: -2})
      should.Throw(test, Error, 'Not a valid data query')

      test = -> DataQuery2.from({flow: 'EXR', lastNObs: 'test'})
      should.Throw(test, Error, 'Not a valid data query')

  describe 'when setting the dimension at observation level', ->

    it 'a string representing the dimension at the obs level can be passed', ->
      flow = 'ECB,EXR,latest'
      dim = 'CURRENCY'
      q = DataQuery2.from({flow: flow, obsDimension: dim})
      q.should.have.property('flow').that.equals flow
      q.should.have.property('obsDimension').that.equals dim

    it 'throws an exception if value for obs dimension is invalid', ->
      test = -> DataQuery2.from({flow: 'EXR', obsDimension: '*&^%$#@!)'})
      should.Throw(test, Error, 'Not a valid data query')

  describe 'when setting whether historical data should be returned', ->

    it 'a boolean can be passed', ->
      flow = 'ECB,EXR'
      q = DataQuery2.from({flow: flow, history: true})
      q.should.have.property('flow').that.equals flow
      q.should.have.property('history').that.is.true

    it 'throws an exception if the value for history is not a boolean', ->
      test = -> DataQuery2.from({flow: 'EXR', history: 'test'})
      should.Throw(test, Error, 'Not a valid data query')

  describe 'when setting the attributes to be returned', ->

    it 'a string representing one set of attributes can be passed', ->
      flow = 'ECB,EXR,latest'
      attrs = 'msd'
      q = DataQuery2.from({flow: flow, attributes: attrs})
      q.should.have.property('flow').that.equals flow
      q.should.have.property('attributes').that.equals attrs

    it 'a string representing multiple sets of attributes can be passed', ->
      flow = 'ECB,EXR,latest'
      attrs = 'msd,dataset,UNIT'
      q = DataQuery2.from({flow: flow, attributes: attrs})
      q.should.have.property('flow').that.equals flow
      q.should.have.property('attributes').that.equals attrs

    it 'throws an exception if value for attributes is invalid', ->
      test = -> DataQuery2.from({flow: 'EXR', attributes: '&1'})
      should.Throw(test, Error, 'Not a valid data query')

  describe 'when setting the measures to be returned', ->

    it 'a string representing one predefined set of measures can be passed', ->
      flow = 'ECB,EXR,latest'
      m = 'all'
      q = DataQuery2.from({flow: flow, measures: m})
      q.should.have.property('flow').that.equals flow
      q.should.have.property('measures').that.equals m

    it 'a string representing multiple measures can be passed', ->
      flow = 'ECB,EXR,latest'
      m = 'TURNOVER,OPEN_INTEREST'
      q = DataQuery2.from({flow: flow, measures: m})
      q.should.have.property('flow').that.equals flow
      q.should.have.property('measures').that.equals m

    it 'throws an exception if value for measures is invalid', ->
      test = -> DataQuery2.from({flow: 'EXR', measures: '&1'})
      should.Throw(test, Error, 'Not a valid data query')
