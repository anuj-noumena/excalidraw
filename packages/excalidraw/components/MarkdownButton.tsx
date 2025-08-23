import clsx from 'clsx';

import { KEYS } from '@excalidraw/common';

import { ToolButton } from './ToolButton';
import { MarkdownIcon } from './icons';

import './ToolIcon.scss';

type LockIconProps = {
    title?: string;
    name?: string;
    isMobile?: boolean;
    onClick?(): void;
};

export const MarkdownButton = (props: LockIconProps) => {
    return (
        <ToolButton
            className={clsx('Markdown', { fillable: false })}
            type="icon"
            icon={MarkdownIcon}
            name="editor-current-markdown"
            title={`${props.title} — H`}
            keyBindingLabel={!props.isMobile ? KEYS.H.toLocaleUpperCase() : undefined}
            aria-label={`${props.title} — H`}
            aria-keyshortcuts={KEYS.H}
            data-testid={`toolbar-markdown`}
            onClick={() => props.onClick?.()}
        />
    );
};
