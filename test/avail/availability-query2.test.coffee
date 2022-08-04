should = require('chai').should()

{AvailabilityMode} = require '../../src/avail/availability-mode'
{AvailabilityReferences} = require '../../src/avail/availability-references'
{AvailabilityQuery2} = require '../../src/avail/availability-query2'

describe 'SDMX 3.0 availability queries', ->

  it 'has the expected properties', ->
    q = AvailabilityQuery2.from {}
    q.should.be.an 'object'
    q.should.have.property 'context'
    q.should.have.property 'key'
    q.should.have.property 'component'
    q.should.have.property 'updatedAfter'
    q.should.have.property 'filters'
    q.should.have.property 'mode'
    q.should.have.property 'references'

  it 'has the expected defaults', ->
    q = AvailabilityQuery2.from {}
    q.should.have.property('context').that.equals '*=*:*(*)'
    q.should.have.property('key').that.equals '*'
    q.should.have.property('component').that.equals '*'
    q.should.have.property('updatedAfter').that.is.undefined
    q.should.have.property('filters').that.is.instanceOf Array
    q.should.have.property('filters').that.has.lengthOf 0
    q.should.have.property('mode').that.equals 'exact'
    q.should.have.property('references').that.equals 'none'

  it 'has the expected defaults, even when nothing gets passed', ->
    q = AvailabilityQuery2.from null
    q.should.have.property('context').that.equals '*=*:*(*)'
    q.should.have.property('key').that.equals '*'
    q.should.have.property('component').that.equals '*'
    q.should.have.property('updatedAfter').that.is.undefined
    q.should.have.property('filters').that.has.lengthOf 0
    q.should.have.property('mode').that.equals 'exact'
    q.should.have.property('references').that.equals 'none'


  describe 'when setting the context', ->

    it 'throws an exception when the context is invalid', ->
      test = -> AvailabilityQuery2.from({context: '1%'})
      should.Throw(test, Error, 'Not a valid availability query')

    it 'accepts the usual context types', ->
      c1 = 'datastructure=BIS:BIS_CBS(1.0)'
      q1 = AvailabilityQuery2.from({context: c1})
      q1.should.have.property('context').that.equals c1

      c2 = 'dataflow=BIS:CBS(1.0)'
      q2 = AvailabilityQuery2.from({context: c2})
      q2.should.have.property('context').that.equals c2

      c3 = 'provisionagreement=BIS:CBS_5B0(1.0)'
      q3 = AvailabilityQuery2.from({context: c3})
      q3.should.have.property('context').that.equals c3

    it 'accepts the new wildcard types', ->
      c = 'dataflow=BIS:*(~)'
      q = AvailabilityQuery2.from({context: c})
      q.should.have.property('context').that.equals c

    it 'accepts multiple values', ->
      c = 'dataflow=BIS:BIS_CBS,BIS_LBS(*)'
      q = AvailabilityQuery2.from({context: c})
      q.should.have.property('context').that.equals c

  describe 'when setting the key', ->

    it 'a string representing the key can be used', ->
      key = 'M.CHF.EUR.SP00.A'
      q = AvailabilityQuery2.from({context: 'dataflow=BIS:CBS(1.0)', key: key})
      q.should.have.property('key').that.equals key

    it 'a string with wildcarded values can be used', ->
      key = 'M.*.EUR.SP00.*'
      q = AvailabilityQuery2.from({context: 'dataflow=BIS:CBS(1.0)', key: key})
      q.should.have.property('key').that.equals key

    it 'a string with multiple keys can be used', ->
      key = 'M.CHF.EUR.SP00.A,D.CHF.EUR.SP00.A'
      q = AvailabilityQuery2.from({context: 'dataflow=BIS:CBS(1.0)', key: key})
      q.should.have.property('key').that.equals key

    it 'throws an exception if the value for the key is invalid', ->
      test = -> AvailabilityQuery2.from({context: 'dataflow=BIS:CBS(1.0)', key: 'M.CHF+NOK.EUR..'})
      should.Throw(test, Error, 'Not a valid availability query')

    it 'throws an exception if one of the values for the key is invalid', ->
      test = -> AvailabilityQuery2.from({context: 'dataflow=BIS:CBS(1.0)', key: 'M.CHF.EUR,M.USD+GBP.EUR'})
      should.Throw(test, Error, 'Not a valid availability query')

  describe 'when setting the component ID', ->
    it 'a string representing the component id can be passed', ->
      cp = 'A'
      query = AvailabilityQuery2.from({context: 'dataflow=BIS:CBS(1.0)', component: cp})
      query.should.have.property('component').that.equals cp

    it 'a string representing multilpe component ids can be passed', ->
      cp = 'A,B'
      query = AvailabilityQuery2.from({context: 'dataflow=BIS:CBS(1.0)', component: cp})
      query.should.have.property('component').that.equals cp

    it 'throws an exception if the component id is invalid', ->
      test = -> AvailabilityQuery2.from({context: 'dataflow=BIS:CBS(1.0)', component: ' '})
      should.Throw(test, Error, 'Not a valid availability query')

      test = -> AvailabilityQuery2.from({context: 'dataflow=BIS:CBS(1.0)', component: 'A*'})
      should.Throw(test, Error, 'Not a valid availability query')

    it 'throws an exception one of the component ids is invalid', ->
      test = -> AvailabilityQuery2.from({context: 'dataflow=BIS:CBS(1.0)', component: 'A,Q*'})
      should.Throw(test, Error, 'Not a valid availability query')  

  describe 'when setting the updatedAfter timestamp', ->

    it 'a string representing a timestamp can be passed', ->
      last = '2016-03-04T09:57:00Z'
      q = AvailabilityQuery2.from({context: 'dataflow=BIS:CBS(1.0)', updatedAfter: last})
      q.should.have.property('updatedAfter').that.equals last

    it 'throws an exception if the value for updatedAfter is invalid', ->
      test = -> AvailabilityQuery2.from({context: 'dataflow=BIS:CBS(1.0)', updatedAfter: 'now'})
      should.Throw(test, Error, 'Not a valid availability query')

      test = -> AvailabilityQuery2.from({context: 'dataflow=BIS:CBS(1.0)', updatedAfter: '2000-Q1'})
      should.Throw(test, Error, 'Not a valid availability query')

  describe 'when setting the filters to be applied', ->

    it 'a string representing one filter can be passed', ->
      f = 'FREQ=A'
      q = AvailabilityQuery2.from({context: 'dataflow=BIS:CBS(1.0)', filters: f})
      q.should.have.property('filters').that.has.lengthOf 1
      r = q.filters[0]
      r.should.equal f

    it 'an array representing multiple filters can be passed', ->
      f1 = 'FREQ=A'
      f2 = 'TIME_PERIOD=ge:2020-01+le:2020-12,2022-08'
      q = AvailabilityQuery2.from({context: 'dataflow=BIS:CBS(1.0)', filters: [f1, f2]})
      q.should.have.property('filters').that.has.lengthOf 2
      r1 = q.filters[0]
      r1.should.equal f1
      r2 = q.filters[1]
      r2.should.equal f2

    it 'throws an exception if the filter is invalid', ->
      test = -> AvailabilityQuery2.from({context: 'dataflow=BIS:CBS(1.0)', filters: 'FREQ=badop:UNIT'})
      should.Throw(test, Error, 'Not a valid availability query')

    it 'throws an exception if one of the filters is invalid', ->
      test = -> AvailabilityQuery2.from({context: 'dataflow=BIS:CBS(1.0)', filters: ['FREQ=A', '$1']})
      should.Throw(test, Error, 'Not a valid availability query')

  describe 'when setting the processing mode', ->
    it 'a string representing the amount of details can be passed', ->
      mode = AvailabilityMode.AVAILABLE
      query = AvailabilityQuery2.from({flow: 'EXR', mode: mode})
      query.should.have.property('mode').that.equals mode

    it 'throws an exception if the value for mode is unknown', ->
      test = -> AvailabilityQuery2.from({flow: 'EXR', mode: 'test'})
      should.Throw(test, Error, 'Not a valid availability query')

  describe 'when setting the references', ->
    it 'a string representing the references to be resolved can be passed', ->
      refs = AvailabilityReferences.CONCEPT_SCHEME
      query = AvailabilityQuery2.from({flow: 'EXR', references: refs})
      query.should.have.property('references').that.equals refs

    it 'throws an exception if the value for references is unknown', ->
      test = -> AvailabilityQuery2.from({flow: 'dataflow', references: 'ref'})
      should.Throw(test, Error, 'Not a valid availability query')