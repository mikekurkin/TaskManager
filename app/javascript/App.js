import React from 'react';

import { ThemeProvider } from '@material-ui/core/styles';
import { ErrorBoundary, Provider as RollbarProvider, LEVEL_WARN } from '@rollbar/react';
import TaskBoard from 'containers/TaskBoard';
import { Provider } from 'react-redux';
import store from 'store';
import theme from 'theme';
import rollbarConfig from 'config/rollbar';

function App() {
  return (
    <RollbarProvider config={rollbarConfig}>
      <ErrorBoundary level={LEVEL_WARN}>
        <Provider store={store}>
          <ThemeProvider theme={theme}>
            <TaskBoard />
          </ThemeProvider>
        </Provider>
      </ErrorBoundary>
    </RollbarProvider>
  );
}

export default App;
