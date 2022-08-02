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
      key = '.CHF+NOK.EUR..2'
      q = DataQuery2.from({flow: flow, key: key})
      q.should.have.property('flow').that.equals flow
      q.should.have.property('key').that.equals key

    it 'an array of arrays can be used to build the key', ->
      values = [
        ['D']
        ['NOK', 'RUB', 'CHF']
        ['EUR']
        []
        ['A']
      ]
      query = DataQuery2.from({flow: 'EXR', key: values})
      query.should.have.property('flow').that.equals 'EXR'
      query.should.have.property('key').that.equals 'D.NOK+RUB+CHF.EUR..A'

    it 'a mixed array can be used to build the key', ->
      values = [
        'D'
        ['NOK', 'RUB', 'CHF']
        ''
        'SP00'
        undefined
      ]
      query = DataQuery2.from({flow: 'EXR', key: values})
      query.should.have.property('flow').that.equals 'EXR'
      query.should.have.property('key').that.equals 'D.NOK+RUB+CHF..SP00.'

    it 'an exotic array can be used to build the key', ->
      values = [
        ''
        ['NOK', 'RUB', 'CHF']
        ['EUR']
        undefined
        null
      ]
      query = DataQuery2.from({flow: 'EXR', key: values})
      query.should.have.property('flow').that.equals 'EXR'
      query.should.have.property('key').that.equals '.NOK+RUB+CHF.EUR..'

    it 'throws an exception if the value for the key is invalid', ->
      test = -> DataQuery2.from({flow: 'EXR', key: '1%'})
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
