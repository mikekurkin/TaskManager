import React from 'react';

import TaskBoard from 'containers/TaskBoard';
import { Provider } from 'react-redux';
import { ThemeProvider } from '@material-ui/core/styles';
import store from 'store';
import theme from 'theme';

function App() {
  return (
    <Provider store={store}>
      <ThemeProvider theme={theme}>
        <TaskBoard />
      </ThemeProvider>
    </Provider>
  );
}

export default App;
