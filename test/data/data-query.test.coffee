should = require('chai').should()
assert = require('chai').assert

{DataDetail} = require '../../src/data/data-detail'
{DataQuery} = require '../../src/data/data-query'

describe 'Data queries', ->

  it 'should have the expected properties', ->
    q = DataQuery.from {flow: 'ICP'}
    q.should.be.an 'object'
    q.should.have.property 'flow'
    q.should.have.property 'key'
    q.should.have.property 'provider'
    q.should.have.property 'start'
    q.should.have.property 'end'
    q.should.have.property 'updatedAfter'
    q.should.have.property 'firstNObs'
    q.should.have.property 'lastNObs'
    q.should.have.property 'obsDimension'
    q.should.have.property 'detail'
    q.should.have.property 'history'

  it 'should have the expected defaults', ->
    flow = 'EXR'
    q = DataQuery.from {flow: flow}
    q.should.have.property('flow').that.equals flow
    q.should.have.property('key').that.equals 'all'
    q.should.have.property('provider').that.equals 'all'
    q.should.have.property('start').that.is.undefined
    q.should.have.property('end').that.is.undefined
    q.should.have.property('updatedAfter').that.is.undefined
    q.should.have.property('firstNObs').that.is.undefined
    q.should.have.property('lastNObs').that.is.undefined
    q.should.have.property('obsDimension').that.equals 'TIME_PERIOD'
    q.should.have.property('detail').that.equals 'full'
    q.should.have.property('history').that.is.false

  it 'should be possible to pass an object with options to create the query', ->
    opts =
      flow: 'EXR'
      key: 'A.CHF.EUR.SP00.A'
      provider: 'ECB'
      start: '2007'
      detail: 'dataonly'
    q = DataQuery.from(opts)
    q.should.have.property('flow').that.equals opts.flow
    q.should.have.property('key').that.equals opts.key
    q.should.have.property('provider').that.equals opts.provider
    q.should.have.property('start').that.equals opts.start
    q.should.have.property('end').that.is.undefined
    q.should.have.property('updatedAfter').that.is.undefined
    q.should.have.property('firstNObs').that.is.undefined
    q.should.have.property('lastNObs').that.is.undefined
    q.should.have.property('obsDimension').that.equals 'TIME_PERIOD'
    q.should.have.property('detail').that.equals opts.detail
    q.should.have.property('history').that.is.false

  it 'should be possible to filter by dimension values', ->
    flow = 'EXR'
    key = '.CHF+NOK.EUR..2'
    q = DataQuery.from({flow: flow, key: key})
    q.should.have.property('flow').that.equals flow
    q.should.have.property('key').that.equals key

  it 'should be possible to filter by provider', ->
    flow = 'EXR'
    provider = 'ECB'
    q = DataQuery.from({flow: flow, provider: provider})
    q.should.have.property('flow').that.equals flow
    q.should.have.property('provider').that.equals provider

    provider = 'SDMX,ECB'
    q = DataQuery.from({flow: flow, provider: provider})
    q.should.have.property('flow').that.equals flow
    q.should.have.property('provider').that.equals provider

  it 'should be possible to filter by years', ->
    flow = 'EXR'
    start = '2000'
    end = '2004'
    q = DataQuery.from({flow: flow, start: start, end: end})
    q.should.have.property('flow').that.equals flow
    q.should.have.property('start').that.equals start
    q.should.have.property('end').that.equals end

  it 'should be possible to filter by months', ->
    flow = 'EXR'
    start = '2000-01'
    end = '2004-12'
    q = DataQuery.from({flow: flow, start: start, end: end})
    q.should.have.property('flow').that.equals flow
    q.should.have.property('start').that.equals start
    q.should.have.property('end').that.equals end

  it 'should be possible to filter by dates', ->
    flow = 'EXR'
    start = '2000-01-01'
    end = '2004-12-31'
    q = DataQuery.from({flow: flow, start: start, end: end})
    q.should.have.property('flow').that.equals flow
    q.should.have.property('start').that.equals start
    q.should.have.property('end').that.equals end

  it 'should be possible to filter by quarters', ->
    flow = 'EXR'
    start = '2000-Q1'
    end = '2004-Q4'
    q = DataQuery.from({flow: flow, start: start, end: end})
    q.should.have.property('flow').that.equals flow
    q.should.have.property('start').that.equals start
    q.should.have.property('end').that.equals end

  it 'should be possible to filter by semesters', ->
    flow = 'EXR'
    start = '2000-S1'
    end = '2004-S4'
    q = DataQuery.from({flow: flow, start: start, end: end})
    q.should.have.property('flow').that.equals flow
    q.should.have.property('start').that.equals start
    q.should.have.property('end').that.equals end

  it 'should be possible to filter by weeks', ->
    flow = 'EXR'
    start = '2000-W01'
    end = '2004-W53'
    q = DataQuery.from({flow: flow, start: start, end: end})
    q.should.have.property('flow').that.equals flow
    q.should.have.property('start').that.equals start
    q.should.have.property('end').that.equals end

  it 'should be possible to request the deltas', ->
    flow = 'EXR'
    last = '2016-03-04T09:57:00Z'
    q = DataQuery.from({flow: flow, updatedAfter: last})
    q.should.have.property('flow').that.equals flow
    q.should.have.property('updatedAfter').that.equals last

  it 'should be possible to set the desired number of observations', ->
    flow = 'EXR'
    firstN = 1
    lastN = 3
    q = DataQuery.from({flow: flow, firstNObs: firstN, lastNObs: lastN})
    q.should.have.property('flow').that.equals flow
    q.should.have.property('firstNObs').that.equals firstN
    q.should.have.property('lastNObs').that.equals lastN

  it 'should be possible to set the dimension at the observation level', ->
    flow = 'ECB,EXR,latest'
    dim = 'CURRENCY'
    q = DataQuery.from({flow: flow, obsDimension: dim})
    q.should.have.property('flow').that.equals flow
    q.should.have.property('obsDimension').that.equals dim

  it 'should be possible to set the desired level of detail', ->
    flow = 'ECB,EXR,1.0'
    detail = DataDetail.NO_DATA
    q = DataQuery.from({flow: flow, detail: detail})
    q.should.have.property('flow').that.equals flow
    q.should.have.property('detail').that.equals detail

  it 'should be possible to request historical data', ->
    flow = 'ECB,EXR'
    q = DataQuery.from({flow: flow, history: true})
    q.should.have.property('flow').that.equals flow
    q.should.have.property('history').that.is.true

  it 'should not be possible to not set the flow', ->
    try
      query = DataQuery.from({flow: ' '})
      assert.fail 'An error should have been triggered'
    catch error
      error.message.should.contain 'Not a valid data query'
      error.message.should.contain 'flow'

    try
      query = DataQuery.from({flow: undefined})
      assert.fail 'An error should have been triggered'
    catch error
      error.message.should.contain 'Not a valid data query'
      error.message.should.contain 'flow'

  it 'should not be possible to set an invalid flow', ->
    try
      query = DataQuery.from({flow: '1%'})
      assert.fail 'An error should have been triggered'
    catch error
      error.message.should.contain 'Not a valid data query'
      error.message.should.contain 'flow'

  it 'must have history as boolean', ->
    try
      query = DataQuery.from({flow: 'EXR', history: 'test'})
      assert.fail 'An error should have been triggered'
    catch error
      error.message.should.contain 'Not a valid data query'
      error.message.should.contain 'history'

  it 'should not be possible to set an unknown value for detail', ->
    try
      query = DataQuery.from({flow: 'EXR', detail: 'test'})
      assert.fail 'An error should have been triggered'
    catch error
      error.message.should.contain 'Not a valid data query'
      error.message.should.contain 'details'

  it 'should not be possible to set a wrong value for obs dimension', ->
    try
      query = DataQuery.from({flow: 'EXR', obsDimension: '*&^%$#@!)'})
      assert.fail 'An error should have been triggered'
    catch error
      error.message.should.contain 'Not a valid data query'
      error.message.should.contain 'dimension'

  it 'should not be possible to set a wrong value for lastNObs', ->
    try
      query = DataQuery.from({flow: 'EXR', lastNObs: -2})
      assert.fail 'An error should have been triggered'
    catch error
      error.message.should.contain 'Not a valid data query'
      error.message.should.contain 'lastN'

    try
      query = DataQuery.from({flow: 'EXR', lastNObs: 'test'})
      assert.fail 'An error should have been triggered'
    catch error
      error.message.should.contain 'Not a valid data query'
      error.message.should.contain 'lastN'

  it 'should not be possible to set a wrong value for firstNObs', ->
    try
      query = DataQuery.from({flow: 'EXR', firstNObs: -2})
      assert.fail 'An error should have been triggered'
    catch error
      error.message.should.contain 'Not a valid data query'
      error.message.should.contain 'firstN'

    try
      query = DataQuery.from({flow: 'EXR', firstNObs: 'test'})
      assert.fail 'An error should have been triggered'
    catch error
      error.message.should.contain 'Not a valid data query'
      error.message.should.contain 'firstN'

  it 'should not be possible to set a wrong value for updatedAfter', ->
    try
      query = DataQuery.from({flow: 'EXR', updatedAfter: 'now'})
      assert.fail 'An error should have been triggered'
    catch error
      error.message.should.contain 'Not a valid data query'
      error.message.should.contain 'updatedAfter'

    try
      query = DataQuery.from({flow: 'EXR', updatedAfter: '2000-Q1'})
      assert.fail 'An error should have been triggered'
    catch error
      error.message.should.contain 'Not a valid data query'
      error.message.should.contain 'updatedAfter'

  it 'should not be possible to set a wrong value for provider', ->
    try
      query = DataQuery.from({flow: 'EXR', provider: 'SDMX,ECB,2.0'})
      assert.fail 'An error should have been triggered'
    catch error
      error.message.should.contain 'Not a valid data query'
      error.message.should.contain 'provider'

  it 'should not be possible to set a wrong value for start period', ->
    try
      query = DataQuery.from({flow: 'EXR', start: 'SDMX,ECB,2.0'})
      assert.fail 'An error should have been triggered'
    catch error
      error.message.should.contain 'Not a valid data query'
      error.message.should.contain 'start'

  it 'should not be possible to set a wrong value for end period', ->
    try
      query = DataQuery.from({flow: 'EXR', end: 'SDMX,ECB,2.0'})
      assert.fail 'An error should have been triggered'
    catch error
      error.message.should.contain 'Not a valid data query'
      error.message.should.contain 'end'

  it 'should not be possible to set a wrong value for the key', ->
    try
      query = DataQuery.from({flow: 'EXR', key: '1%'})
      assert.fail 'An error should have been triggered'
    catch error
      error.message.should.contain 'Not a valid data query'
      error.message.should.contain 'key'
