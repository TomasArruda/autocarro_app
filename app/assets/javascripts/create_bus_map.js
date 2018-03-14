var cy = cytoscape({
  container: document.getElementById('cy'),
  elements: [
    { data: { id: 'a', classes: 'bob' } },
    { data: { id: 'b', classes: 'pa' } },
    { data: { id: 'c', classes: 'pa' } },
    { data: { id: 'd', classes: 'pa' } },
    { data: { id: 'e', classes: 'pa' } },
    { data: { id: 'f', classes: 'pa' } },
    {
      data: {
        id: 'ab',
        source: 'a',
        target: 'b',
      }
    },
    {
      data: {
        id: 'cd',
        source: 'c',
        target: 'd'
      }
    },
    {
      data: {
        id: 'ef',
        source: 'e',
        target: 'f'
      }
    },
    {
      data: {
        id: 'ac',
        source: 'a',
        target: 'c'
      }
    },
    {
      data: {
        id: 'be',
        source: 'b',
        target: 'e'
      }
    }
  ],


    style: [ 
      {
        selector: '.pa',
        style: {
          'background-color': '#666',
          'label': 'data(id)'
        }
      },

      {
        selector: '.bob',
        style: {
          'background-color': 'red',
          'label': 'data(id)'
        }
      },

      {
        selector: 'edge',
        style: {
          'width': 3,
          'line-color': '#ccc',
          'target-arrow-color': '#ccc',
          'target-arrow-shape': 'triangle'
        }
      }
    ],

    layout: {
      name: 'grid',
      rows: 1
    }     
});