import { updateActiveTool } from '@excalidraw/common';

import { CaptureUpdateAction } from '@excalidraw/element';

import { setCursorForShape } from '../cursor';

import { register } from './register';

export const actionSetEmbeddableAsActiveTool = register({
    name: 'setEmbeddableAsActiveTool',
    trackEvent: { category: 'toolbar' },
    target: 'Tool',
    label: 'toolBar.embeddable',
    perform: (elements, appState, _, app) => {
        const nextActiveTool = updateActiveTool(appState, {
            type: 'embeddable'
        });

        setCursorForShape(app.canvas, {
            ...appState,
            activeTool: nextActiveTool
        });

        return {
            elements,
            appState: {
                ...appState,
                activeTool: updateActiveTool(appState, {
                    type: 'embeddable'
                })
            },
            captureUpdate: CaptureUpdateAction.EVENTUALLY
        };
    }
});

export const actionSetMarkdownAsActiveTool = register({
    name: 'setMarkdownAsActiveTool',
    trackEvent: { category: 'toolbar' },
    target: 'Tool',
    label: 'toolBar.markdown',
    perform: (elements, appState, _, app) => {
        const nextActiveTool = updateActiveTool(appState, {
            type: 'embeddable'
        });

        setCursorForShape(app.canvas, {
            ...appState,
            activeTool: nextActiveTool
        });

        return {
            elements,
            appState: {
                ...appState,
                activeTool: updateActiveTool(appState, {
                    type: 'embeddable'
                })
            },
            captureUpdate: CaptureUpdateAction.EVENTUALLY
        };
    }
});

export const actionSetMindmapAsActiveTool = register({
    name: 'setMindmapAsActiveTool',
    trackEvent: { category: 'toolbar' },
    target: 'Tool',
    label: 'toolBar.mindmap',
    perform: (elements, appState, _, app) => {
        const nextActiveTool = updateActiveTool(appState, {
            type: 'embeddable'
        });

        setCursorForShape(app.canvas, {
            ...appState,
            activeTool: nextActiveTool
        });

        return {
            elements,
            appState: {
                ...appState,
                activeTool: updateActiveTool(appState, {
                    type: 'embeddable'
                })
            },
            captureUpdate: CaptureUpdateAction.EVENTUALLY
        };
    }
});
