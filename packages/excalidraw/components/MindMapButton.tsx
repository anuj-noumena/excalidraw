import clsx from "clsx";

import { KEYS } from "@excalidraw/common";

import { ToolButton } from "./ToolButton";
import { MindMapIcon } from "./icons";

import "./ToolIcon.scss";

type LockIconProps = {
  title?: string;
  name?: string;
  onClick?(): void;
  isMobile?: boolean;
};

export const MindMapButton = (props: LockIconProps) => {
  return (
    <ToolButton
      className={clsx("MindMap", { fillable: false })}
      type="icon"
      icon={MindMapIcon}
      name="editor-current-mindmap"
      title={`${props.title} — H`}
      keyBindingLabel={!props.isMobile ? KEYS.H.toLocaleUpperCase() : undefined}
      aria-label={`${props.title} — H`}
      aria-keyshortcuts={KEYS.H}
      data-testid={`toolbar-mindmap`}
      onClick={() => props.onClick?.()}
    />
  );
};
